//
//  CoreDataStack.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  private let modelName = "Chats"

  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()

  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()

  func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
    storeContainer.performBackgroundTask { (context) in
      context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      block(context)
      if context.hasChanges {
        do {
          try self.performSave(in: context)
        } catch {
          assertionFailure(error.localizedDescription)
        }
      }
    }
  }

  private func performSave(in context: NSManagedObjectContext) throws {
    try context.save()
    if let parent = context.parent {
      try performSave(in: parent)
    }
  }
}
