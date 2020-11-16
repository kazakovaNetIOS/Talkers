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
  var delegate: MessagesCoreDataServiceDelegateProtocol? { get set }
  func addMessages(_ messages: [Message], in channelId: String)
  func fetchMessages(in channelId: String)
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO>?
}

protocol MessagesCoreDataServiceDelegateProtocol: class {
  func processCoreDataError(with message: String)
  func coreDataDidFinishFetching(in channelId: String)
}

class MessagesCoreDataService {
  weak var delegate: MessagesCoreDataServiceDelegateProtocol?
  private var coreDataStack: CoreDataStackProtocol
  private var channelsCoreDataService: ChannelsCoreDataServiceProtocol
  private var fetchedResultsController: NSFetchedResultsController<MessageMO>?

  init(coreDataStack: CoreDataStackProtocol,
       channelsCoreDataService: ChannelsCoreDataServiceProtocol) {
    self.coreDataStack = coreDataStack
    self.channelsCoreDataService = channelsCoreDataService
  }
}

// MARK: - MessagesCoreDataServiceProtocol

extension MessagesCoreDataService: MessagesCoreDataServiceProtocol {
  func getFRC(with channelId: String) -> NSFetchedResultsController<MessageMO>? {
    let fetchRequest: NSFetchRequest<MessageMO> = MessageMO.fetchRequest()

    let predicate = NSPredicate(format: "\(#keyPath(MessageMO.channel.identifier)) == %@", channelId)
    fetchRequest.predicate = predicate

    let sortDescriptor = NSSortDescriptor(key: #keyPath(MessageMO.created), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                      managedObjectContext: coreDataStack.managedContext,
                                      sectionNameKeyPath: nil,
                                      cacheName: nil)
    return self.fetchedResultsController
  }

  func addMessages(_ messages: [Message], in channelId: String) {
    coreDataStack.performSave {[weak self] (context) in
      guard let channel = self?.channelsCoreDataService.getChannel(by: channelId, in: context) else {
        self?.delegate?.processCoreDataError(with: "Error while receiving channel")
        return
      }
      _ = messages.map { MessageMO(with: $0, channel: channel, in: context) }
    }
  }

  func fetchMessages(in channelId: String) {
    if self.fetchedResultsController == nil {
      _ = getFRC(with: channelId)
    }

    guard let frc = self.fetchedResultsController else { return }

    do {
      try frc.performFetch()
    } catch {
      let fetchError = error as NSError
      self.delegate?.processCoreDataError(with: "\(fetchError), \(fetchError.localizedDescription)")
    }

    self.delegate?.coreDataDidFinishFetching(in: channelId)
  }
}
