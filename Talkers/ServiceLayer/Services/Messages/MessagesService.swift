//
//  MessagesService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol MessagesServiceProtocol {
  var delegate: MessagesServiceDelegateProtocol? { get set }
  func addMessage(with message: Message, in channelId: String)
  func fetchMessages(in channel: ChannelMO)
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO>
}

protocol MessagesServiceDelegateProtocol: class {
  func processError(with message: String)
}

class MessagesService {
  weak var delegate: MessagesServiceDelegateProtocol?
  private var firebaseService: MessagesFirebaseServiceProtocol
  private var coreDataService: MessagesCoreDataServiceProtocol

  init(firebaseService: MessagesFirebaseServiceProtocol,
       coreDataService: MessagesCoreDataServiceProtocol) {
    self.firebaseService = firebaseService
    self.coreDataService = coreDataService
    self.firebaseService.delegate = self
  }
}

// MARK: - MessagesServiceProtocol

extension MessagesService: MessagesServiceProtocol {
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO> {
    return coreDataService.getFRC(with: channelId)
  }

  func addMessage(with message: Message, in channelId: String) {
    firebaseService.addMessage(with: message, in: channelId)
  }

  func fetchMessages(in channel: ChannelMO) {
    firebaseService.fetchMessages(in: channel)
  }
}

// MARK: - MessagesFirebaseServiceDelegateProtocol

extension MessagesService: MessagesFirebaseServiceDelegateProtocol {
  func processFirebaseError(with message: String) {
    delegate?.processError(with: message)
  }

  func firebaseDidFinishFetching(in channel: ChannelMO) {
    coreDataService.save(messages: firebaseService.messages, in: channel)
  }
}
