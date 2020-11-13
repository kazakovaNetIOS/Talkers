//
//  ConversationModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationModelProtocol {
  var delegate: ConversationModelDelegateProtocol? { get set }
  var channel: ChannelMO { get }
  var tableViewDataSource: ConversationTableViewDataSource { get }

  func addMessage(with messageText: String)
  func fetchMessages()
  func getMessage(at indexPath: IndexPath) -> MessageMO
  func getNumbersOfObjects(for section: Int) -> Int
  func getMessagesCount() -> Int
  func setFRCDelegate(delegate: NSFetchedResultsControllerDelegate)
}

protocol ConversationModelDelegateProtocol: class {
  func show(error message: String)
}

class ConversationModel {
  weak var delegate: ConversationModelDelegateProtocol?
  private var messagessService: MessagesServiceProtocol
  private var userProfileService: UserProfileServiceProtocol
  var channel: ChannelMO

  lazy var fetchedResultsController: NSFetchedResultsController<MessageMO> = {
    guard let channelId = channel.identifier else {
      fatalError("Can't initialize model for conversation")
    }
    return messagessService.getFRC(with: channelId)
  }()
  lazy var tableViewDataSource: ConversationTableViewDataSource = {
    return ConversationTableViewDataSource(model: self)
  }()

  init(channelsService: MessagesServiceProtocol,
       userProfileService: UserProfileServiceProtocol,
       channel: ChannelMO) {
    self.messagessService = channelsService
    self.userProfileService = userProfileService
    self.channel = channel
    self.messagessService.delegate = self
  }
}

// MARK: - ConversationModelProtocol

extension ConversationModel: ConversationModelProtocol {
  func addMessage(with messageText: String) {
    let senderId = userProfileService.getSenderId()
    let userProfile = userProfileService.getUserProfile()
    let newMessage = Message(content: messageText,
                             created: Date(),
                             senderId: senderId,
                             senderName: userProfile.name ?? "")

    guard let channelId = channel.identifier else {
      fatalError("Can't initialize model for conversation")
    }

    messagessService.addMessage(with: newMessage, in: channelId)
  }

  func fetchMessages() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }

      do {
        try self.fetchedResultsController.performFetch()
      } catch {
        let fetchError = error as NSError
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.delegate?.show(error: "\(fetchError), \(fetchError.localizedDescription)")
        }
      }

      DispatchQueue.global(qos: .userInitiated).async {
        self.messagessService.fetchMessages(in: self.channel)
      }
    }
  }

  func getMessage(at indexPath: IndexPath) -> MessageMO {
    return fetchedResultsController.object(at: indexPath)
  }

  func getNumbersOfObjects(for section: Int) -> Int {
    guard let sections = self.fetchedResultsController.sections else { return 0 }

    let sectionsInfo = sections[section]
    return sectionsInfo.numberOfObjects
  }

  func getMessagesCount() -> Int {
    if let count = fetchedResultsController.fetchedObjects?.count {
      return count
    }

    return 0
  }

  func setFRCDelegate(delegate: NSFetchedResultsControllerDelegate) {
    fetchedResultsController.delegate = delegate
  }
}

// MARK: - MessagesServiceDelegateProtocol

extension ConversationModel: MessagesServiceDelegateProtocol {
  func processError(with message: String) {
    delegate?.show(error: message)
  }
}
