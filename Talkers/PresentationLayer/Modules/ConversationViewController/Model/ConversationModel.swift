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
  var currentThemeSettings: ThemeSettings { get }

  func addMessage(with messageText: String)
  func fetchMessages()
  func getMessage(at indexPath: IndexPath) -> Message
  func getNumbersOfObjects(for section: Int) -> Int
  func getMessagesCount() -> Int
  func setFRCDelegate(delegate: NSFetchedResultsControllerDelegate)
}

protocol ConversationModelDelegateProtocol: class {
  func show(error message: String)
}

class ConversationModel {
  weak var delegate: ConversationModelDelegateProtocol?
  private var messagesService: MessagesServiceFacadeProtocol
  private var profileService: ProfileServiceFacadeProtocol
  private var themesService: ThemesServiceProtocol
  var channel: ChannelMO

  lazy var fetchedResultsController: NSFetchedResultsController<MessageMO> = {
    guard let channelId = channel.identifier,
          let frc = messagesService.getFRC(with: channelId) else {
      fatalError("Can't initialize model for conversation")
    }
    return frc
  }()
  lazy var tableViewDataSource: ConversationTableViewDataSource = {
    return ConversationTableViewDataSource(model: self)
  }()
  var currentThemeSettings: ThemeSettings {
    return themesService.currentThemeSettings
  }

  init(messagesService: MessagesServiceFacadeProtocol,
       profileService: ProfileServiceFacadeProtocol,
       themesService: ThemesServiceProtocol,
       channel: ChannelMO) {
    self.messagesService = messagesService
    self.profileService = profileService
    self.themesService = themesService
    self.channel = channel
    self.messagesService.delegate = self
  }
}

// MARK: - ConversationModelProtocol

extension ConversationModel: ConversationModelProtocol {
  func addMessage(with messageText: String) {
    let mySenderId = profileService.getSenderId()
    profileService.loadProfile {[weak self] (result) in
      switch result {
      case .success(let profile):
        let newMessage = Message(content: messageText,
                                 created: Date(),
                                 senderId: mySenderId,
                                 senderName: profile.name ?? "",
                                 isMyMessage: true)

        guard let channelId = self?.channel.identifier else {
          fatalError("Can't initialize model for conversation")
        }

        self?.messagesService.addMessage(with: newMessage, in: channelId)
      case .failure(let error):
        fatalError("Can't initialize model for conversation, \(error)")
      }
    }
  }

  func fetchMessages() {
    guard let channelId = channel.identifier else { return }
    messagesService.fetchMessages(in: channelId, mySenderId: profileService.getSenderId())
  }

  func getMessage(at indexPath: IndexPath) -> Message {
    let messageMO = fetchedResultsController.object(at: indexPath)
    let senderId = messageMO.senderId
    let mySenderId = profileService.getSenderId()
    return Message(messageMO, isMyMessage: senderId == mySenderId)
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
