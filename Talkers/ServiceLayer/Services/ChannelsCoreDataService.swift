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
}

class ChannelsCoreDataService {
  private var coreDataStorage: ChannelsCoreDataStorageProtocol

  init(coreDataStorage: ChannelsCoreDataStorageProtocol) {
    self.coreDataStorage = coreDataStorage
  }
}

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
}
