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

  var profileService: ProfileServiceProtocol { get }
  var profileGCDService: ProfileGCDServiceProtocol { get }
  var profileOperationService: ProfileOperationServiceProtocol { get }

  var themesService: ThemesService { get }

  var profileImagesService: ProfileImagesServiceProtocol { get }
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

  lazy var profileGCDService: ProfileGCDServiceProtocol = ProfileGCDService(fileStorage: coreAssembly.fileStorage)
  lazy var profileOperationService: ProfileOperationServiceProtocol = ProfileOperationService(fileStorage: coreAssembly.fileStorage)
  lazy var profileService: ProfileServiceProtocol = ProfileService(profileGSDService: profileGCDService,
                                                                   profileOperationService: profileOperationService)

  lazy var themesService: ThemesService = ThemesService()

  lazy var profileImagesService: ProfileImagesServiceProtocol = ProfileImagesService(requestSender: coreAssembly.requestSender)
}
