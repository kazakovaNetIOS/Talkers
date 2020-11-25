//
//  ChannelsCoreDataStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 10.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStorageProtocol {
  var coreDataStack: CoreDataStackProtocol { get }
}

class CoreDataStorage: CoreDataStorageProtocol {
  var coreDataStack: CoreDataStackProtocol

  init(coreDataStack: CoreDataStackProtocol) {
    self.coreDataStack = coreDataStack
  }
}
