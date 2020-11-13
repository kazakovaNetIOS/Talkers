//
//  ChannelsCoreDataStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 10.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol CoreDataStorageProtocol {
  var frcRepository: FRCRepositoryProtocol { get }
  var coreDataStack: CoreDataStack { get }
}

class CoreDataStorage: CoreDataStorageProtocol {
  lazy var frcRepository: FRCRepositoryProtocol = {
    return FRCChannelsRepository(context: self.coreDataStack.managedContext)
  }()
  var coreDataStack: CoreDataStack

  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }
}
