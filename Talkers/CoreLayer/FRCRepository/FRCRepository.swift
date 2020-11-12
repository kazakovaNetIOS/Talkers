//
//  FRCRepository.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol FRCRepositoryProtocol {
  func getFRC<Object: NSManagedObject>(fetchRequest: NSFetchRequest<Object>,
                                       sectionNameKeyPath: String?,
                                       cacheName: String?) -> NSFetchedResultsController<Object>
}
