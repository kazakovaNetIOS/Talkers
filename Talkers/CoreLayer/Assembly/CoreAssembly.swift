//
//  CoreAssembly.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
  var channelsFirebaseStorage: ChannelsFirebaseStorageProtocol { get }
  var channelsCoreDataStorage: ChannelsCoreDataStorageProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
  lazy var channelsFirebaseStorage: ChannelsFirebaseStorageProtocol = ChannelsFirebaseStorage()
  lazy var channelsCoreDataStorage: ChannelsCoreDataStorageProtocol = ChannelsCoreDataStorage(coreDataStack: CoreDataStack())
}
