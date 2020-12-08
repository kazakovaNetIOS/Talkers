//
//  CoreDataStackMock.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 04.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers
import CoreData

class CoreDataStackMock {

}

// MARK: - CoreDataStackProtocol

extension CoreDataStackMock: CoreDataStackProtocol {
  var managedContext: NSManagedObjectContext {
    fatalError("Need to implement!")
  }

  func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {

  }
}
