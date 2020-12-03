//
//  ChannelsCoreDataServiceMock.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 04.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers
import CoreData

class ChannelsCoreDataServiceMock {
  var callsCount: Int = 0
  var receivedChannelId: String?

  var delegate: ChannelsCoreDataServiceDelegateProtocol?
  lazy var fetchedResultsController: NSFetchedResultsController<ChannelMO> = {
    fatalError("Need to implement!")
  }()
}

// MARK: - ChannelsCoreDataServiceProtocol

extension ChannelsCoreDataServiceMock: ChannelsCoreDataServiceProtocol {
  func deleteChannel(channel: ChannelMO) {

  }

  func upsert(_ channels: [Channel]) {

  }

  func getChannel(by id: String, in context: NSManagedObjectContext) -> ChannelMO? {
    callsCount += 1
    receivedChannelId = id
    return nil
  }

  func fetchChannels() {

  }
}
