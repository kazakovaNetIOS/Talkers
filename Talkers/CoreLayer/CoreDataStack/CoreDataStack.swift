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
    self.storeContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return self.storeContainer.newBackgroundContext()
  }()

  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  func saveContext () {
    guard managedContext.hasChanges else { return }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }

  func delete(object: NSManagedObject) {
    managedContext.delete(object)
    saveContext()
  }
}
