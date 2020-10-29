//
//  CoreDataStack.swift
//  Talkers
//
//  Created by Natalia Kazakova on 29.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  var didUpdateDatabase: ((CoreDataStack) -> Void)?

  private var storeUrl: URL = {
    guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).last
    else {
      fatalError("document path not found")
    }
    return documentsUrl.appendingPathComponent("Chats.sqlite")
  }()

  private let dataModelName = "Chats"
  private let dataModelExtension = "momd"

  // MARK: - Init Stack

  private(set) lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                         withExtension: self.dataModelExtension)
    else {
      fatalError("model not found")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
    else {
      fatalError("managedObjectModel could not be created")
    }

    return managedObjectModel
  }()

  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                         configurationName: nil,
                                         at: self.storeUrl,
                                         options: nil)
    } catch {
      fatalError(error.localizedDescription)
    }

    return coordinator
  }()

  // MARK: - Contexts

  private lazy var writterContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.persistentStoreCoordinator = self.persistentStoreCoordinator
    context.mergePolicy = NSOverwriteMergePolicy
    return context
  }()

  private(set) lazy var mainContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = writterContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return context
  }()

  private func saveContext() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = mainContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return context
  }

  // MARK: - Save Context

  func performSave(_ block: (NSManagedObjectContext) -> Void) {
    let context = saveContext()
    context.performAndWait {
      block(context)
      if context.hasChanges {
        do {
          try performSave(in: context)
        } catch {
          assertionFailure(error.localizedDescription)
        }
      }
    }
  }

  private func performSave(in context: NSManagedObjectContext) throws {
    try context.save()
    if let parent = context.parent { try performSave(in: parent) }
  }

  // MARK: - CoreData Observers

  func enableObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                   name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                   object: mainContext)
  }

  @objc
  private func managedObjectContextObjectsDidChange(notification: NSNotification) {
    guard let userInfo = notification.userInfo else { return }

    didUpdateDatabase?(self)

    if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
       inserts.count > 0 {
      print("Добавлено объектов: ", inserts.count)
    }

    if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
       updates.count > 0 {
      print("Обновлено объектов: ", updates.count)
    }

    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
       deletes.count > 0 {
      print("Удалено объектов: ", deletes.count)
    }
  }

  // MARK: - Core Data Logs

  func printDatabaseStatistic() {
    mainContext.perform {
      do {
        let countChannels = try self.mainContext.count(for: ChannelMO.fetchRequest())
        let countMessages = try self.mainContext.count(for: MessageMO.fetchRequest())

        print("В базе сохранено \(countChannels) каналов, \(countMessages) сообщений")

          // TODO: - чтение данных из БД в главном потоке (возможно использование для логирования),
          // закомментировано, так как захламляет лог при выводе данных о каждом канале / сообщении
//        let arrayChannels = try self.mainContext.fetch(ChannelMO.fetchRequest()) as? [ChannelMO] ?? []
//        arrayChannels.forEach { print($0.name ?? "") }
//        let arrayMessages = try self.mainContext.fetch(MessageMO.fetchRequest()) as? [MessageMO] ?? []
//        arrayMessages.forEach { print($0.content ?? "") }
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }
}
