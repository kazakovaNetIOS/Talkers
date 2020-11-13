//
//  MessagesCoreDataService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol MessagesCoreDataServiceProtocol {
  func save(messages: [Message], in channel: ChannelMO)
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO>
}

class MessagesCoreDataService {
  private var coreDataStorage: CoreDataStorageProtocol

  init(coreDataStorage: CoreDataStorageProtocol) {
    self.coreDataStorage = coreDataStorage
  }
}

// MARK: - MessagesCoreDataServiceProtocol

extension MessagesCoreDataService: MessagesCoreDataServiceProtocol {
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO> {
    let fetchRequest: NSFetchRequest<MessageMO> = MessageMO.fetchRequest()

    let predicate = NSPredicate(format: "\(#keyPath(MessageMO.channel.identifier)) == %@", channelId)
    fetchRequest.predicate = predicate

    let sortDescriptor = NSSortDescriptor(key: #keyPath(MessageMO.created), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    return coreDataStorage.frcRepository.getFRC(fetchRequest: fetchRequest,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
  }

  func save(messages: [Message], in channel: ChannelMO) {
    let messageRequest = MessagesRequest(coreDataStack: self.coreDataStorage.coreDataStack)
    messageRequest.makeRequest(messages: messages, in: channel)
  }
}
