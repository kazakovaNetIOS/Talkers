//
//  ServiceAssembly.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ServiceAssemblyProtocol {
  var channelsService: ChannelsServiceProtocol { get }
  var channelsFirebaseService: ChannelsFirebaseServiceProtocol { get }
  var channelsCoreDataService: ChannelsCoreDataServiceProtocol { get }

  var messagesService: MessagesServiceProtocol { get }
  var messagesFirebaseService: MessagesFirebaseServiceProtocol { get }
  var messagesCoreDataService: MessagesCoreDataServiceProtocol { get }

  var userProfileService: UserProfileServiceProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
  private let coreAssembly: CoreAssemblyProtocol

  init(coreAssembly: CoreAssemblyProtocol) {
    self.coreAssembly = coreAssembly
  }

  lazy var channelsFirebaseService: ChannelsFirebaseServiceProtocol = ChannelsFirebaseService(firebaseStorage: coreAssembly.firebaseStorage)
  lazy var channelsCoreDataService: ChannelsCoreDataServiceProtocol = ChannelsCoreDataService(coreDataStack: coreAssembly.coreDataStorage.coreDataStack)
  lazy var channelsService: ChannelsServiceProtocol = ChannelsService(firebaseService: channelsFirebaseService,
                                                                      coreDataService: channelsCoreDataService)

  lazy var messagesFirebaseService: MessagesFirebaseServiceProtocol = MessagesFirebaseService(firebaseStorage: coreAssembly.firebaseStorage)
  lazy var messagesCoreDataService: MessagesCoreDataServiceProtocol = MessagesCoreDataService(coreDataStack: coreAssembly.coreDataStorage.coreDataStack,
                                                                                              channelsCoreDataService: channelsCoreDataService)
  lazy var messagesService: MessagesServiceProtocol = MessagesService(firebaseService: messagesFirebaseService,
                                                                      coreDataService: messagesCoreDataService)

  lazy var userProfileService: UserProfileServiceProtocol = UserProfileService(dataManager: UserProfileOperationDataManager())
}
