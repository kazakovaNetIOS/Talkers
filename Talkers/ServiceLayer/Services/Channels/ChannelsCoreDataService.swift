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
  func deleteChannel(channel: ChannelMO)
  func save(channels: [Channel])
  func getFRC() -> NSFetchedResultsController<ChannelMO>
  func getChannel(by id: String) -> ChannelMO?
}

class ChannelsCoreDataService {
  private var coreDataStorage: CoreDataStorageProtocol

  init(coreDataStorage: CoreDataStorageProtocol) {
    self.coreDataStorage = coreDataStorage
  }
}

// MARK: - ChannelsCoreDataServiceProtocol

extension ChannelsCoreDataService: ChannelsCoreDataServiceProtocol {
  func getFRC() -> NSFetchedResultsController<ChannelMO> {
    let fetchRequest: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()

    let sortDescriptor = NSSortDescriptor(key: #keyPath(ChannelMO.lastActivity), ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    return coreDataStorage.frcRepository.getFRC(fetchRequest: fetchRequest,
                                sectionNameKeyPath: nil,
                                cacheName: nil)
  }

  func deleteChannel(channel: ChannelMO) {
    coreDataStorage.coreDataStack.delete(object: channel)
  }

  func save(channels: [Channel]) {
    let channelsRequest = ChannelsRequest(coreDataStack: self.coreDataStorage.coreDataStack)
    channelsRequest.makeRequest(channels: channels)
  }

  func getChannel(by id: String) -> ChannelMO? {
    let context = CoreDataStack().managedContext

    let request: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()

    let predicate = NSPredicate(format: "identifier = %@", id)
    request.predicate = predicate

    let result = try? context.fetch(request)
    if let channel = result?.first {
      return channel
    } else {
      return nil
    }
  }
}
