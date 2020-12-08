//
//  MessagesServiceFacade.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol MessagesServiceFacadeProtocol {
  var delegate: MessagesServiceDelegateProtocol? { get set }
  func addMessage(with message: Message, in channelId: String)
  func fetchMessages(in channelId: String, mySenderId: String)
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO>?
}

protocol MessagesServiceDelegateProtocol: class {
  func processError(with message: String)
}

class MessagesServiceFacade {
  weak var delegate: MessagesServiceDelegateProtocol?
  private var firebaseService: MessagesFirebaseServiceProtocol
  private var coreDataService: MessagesCoreDataServiceProtocol
  private var mySenderId: String?

  init(firebaseService: MessagesFirebaseServiceProtocol,
       coreDataService: MessagesCoreDataServiceProtocol) {
    self.firebaseService = firebaseService
    self.coreDataService = coreDataService
    self.firebaseService.delegate = self
    self.coreDataService.delegate = self
  }
}

// MARK: - MessagesServiceProtocol

extension MessagesServiceFacade: MessagesServiceFacadeProtocol {
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO>? {
    return coreDataService.getFRC(with: channelId)
  }

  func addMessage(with message: Message, in channelId: String) {
    firebaseService.addMessage(with: message, in: channelId)
  }

  func fetchMessages(in channelId: String, mySenderId: String) {
    self.mySenderId = mySenderId
    coreDataService.fetchMessages(in: channelId)
  }
}

// MARK: - MessagesFirebaseServiceDelegateProtocol

extension MessagesServiceFacade: MessagesFirebaseServiceDelegateProtocol {
  func processFirebaseError(with message: String) {
    delegate?.processError(with: "Error in Firebase, \(message)")
  }

  func firebaseDidFinishFetching(in channelId: String) {
    coreDataService.addMessages(firebaseService.messages, in: channelId)
  }
}

// MARK: - MessagesCoreDataServiceDelegateProtocol

extension MessagesServiceFacade: MessagesCoreDataServiceDelegateProtocol {
  func coreDataDidFinishFetching(in channelId: String) {
    guard let mySenderId = self.mySenderId else { return }
    firebaseService.fetchMessages(in: channelId, mySenderId: mySenderId)
  }

  func processCoreDataError(with message: String) {
    self.delegate?.processError(with: "Error in CoreData, \(message)")
  }
}
