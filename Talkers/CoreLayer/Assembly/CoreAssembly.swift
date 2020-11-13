//
//  CoreAssembly.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
  var firebaseStorage: FirebaseStorageProtocol { get }
  var coreDataStorage: CoreDataStorageProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
  lazy var firebaseStorage: FirebaseStorageProtocol = FirebaseStorage()
  lazy var coreDataStorage: CoreDataStorageProtocol = CoreDataStorage(coreDataStack: CoreDataStack())
}
