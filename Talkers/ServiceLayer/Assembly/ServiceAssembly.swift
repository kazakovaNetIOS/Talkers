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
}

class ServiceAssembly: ServiceAssemblyProtocol {
  private let coreAssembly: CoreAssemblyProtocol

  init(coreAssembly: CoreAssemblyProtocol) {
    self.coreAssembly = coreAssembly
  }

  lazy var channelsService: ChannelsServiceProtocol = ChannelsService(firebaseService: ChannelsFirebaseService(firebaseStorage: coreAssembly.channelsFirebaseStorage),
                                                                      coreDataService: ChannelsCoreDataService(coreDataStorage: coreAssembly.channelsCoreDataStorage))
}
