//
//  FRCChannelsRepository.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

class FRCChannelsRepository {
  private var managedContext: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.managedContext = context
  }
}

// MARK: - FRCRepositoryProtocol

extension FRCChannelsRepository: FRCRepositoryProtocol {
  func getFRC<Object: NSManagedObject>(fetchRequest: NSFetchRequest<Object>,
                                       sectionNameKeyPath: String?,
                                       cacheName: String?) -> NSFetchedResultsController<Object> {
    return NSFetchedResultsController(fetchRequest: fetchRequest,
                                      managedObjectContext: managedContext,
                                      sectionNameKeyPath: sectionNameKeyPath,
                                      cacheName: cacheName)
  }
}
