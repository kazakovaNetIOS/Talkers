//
//  ChannelsCoreDataService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelsCoreDataServiceProtocol {
  var delegate: ChannelsCoreDataServiceDelegateProtocol? { get set }
  var fetchedResultsController: NSFetchedResultsController<ChannelMO> { get }
  func deleteChannel(channel: ChannelMO)
  func upsert(_ channels: [Channel])
  func getChannel(by id: String, in context: NSManagedObjectContext) -> ChannelMO?
  func fetchChannels()
}

protocol ChannelsCoreDataServiceDelegateProtocol: class {
  func processCoreDataError(with message: String)
  func coreDataDidFinishFetching()
}

class ChannelsCoreDataService {
  private var coreDataStack: CoreDataStack
  weak var delegate: ChannelsCoreDataServiceDelegateProtocol?
  lazy var fetchedResultsController: NSFetchedResultsController<ChannelMO> = {
    let fetchRequest: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()

    let sortDescriptor = NSSortDescriptor(key: #keyPath(ChannelMO.lastActivity), ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    return NSFetchedResultsController(fetchRequest: fetchRequest,
                                      managedObjectContext: coreDataStack.managedContext,
                                      sectionNameKeyPath: nil,
                                      cacheName: nil)
  }()

  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }
}

// MARK: - ChannelsCoreDataServiceProtocol

extension ChannelsCoreDataService: ChannelsCoreDataServiceProtocol {
  func deleteChannel(channel: ChannelMO) {
    coreDataStack.performSave {[weak self] (context) in
      guard let self = self,
            let channelId = channel.identifier else { return }

      let fetchRequest: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()
      let predicate = NSPredicate(format: "identifier = %@", channelId)
      fetchRequest.predicate = predicate

      do {
        let channels = try context.fetch(fetchRequest)
        guard let deletedChannel = channels.first else { return }
        context.delete(deletedChannel)
      } catch {
        self.delegate?.processCoreDataError(with: error.localizedDescription)
      }
    }
  }

  func upsert(_ channels: [Channel]) {
    coreDataStack.performSave {[weak self] (context) in
      guard let self = self else { return }

      channels.forEach {
        if let channel = self.getChannel(by: $0.identifier, in: context) {
          channel.setValue($0.lastActivity, forKey: "lastActivity")
          channel.setValue($0.lastMessage, forKey: "lastMessage")
          channel.setValue($0.name, forKey: "name")
        } else {
          _ = ChannelMO(with: $0, in: context)
        }
      }
    }
  }

  func getChannel(by id: String, in context: NSManagedObjectContext) -> ChannelMO? {
    let request: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()
    let predicate = NSPredicate(format: "identifier = %@", id)
    request.predicate = predicate

    let result = try? context.fetch(request)
    return result?.first
  }

  func fetchChannels() {
    do {
      try self.fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      self.delegate?.processCoreDataError(with: "\(fetchError), \(fetchError.localizedDescription)")
    }

    self.delegate?.coreDataDidFinishFetching()
  }
}
