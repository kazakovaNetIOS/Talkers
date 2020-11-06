//
//  CoreDataManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
  func getChannel(by id: String) -> ChannelMO? {
    let context = CoreDataStack.share.managedContext

    let request: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()

    let predicate = NSPredicate(format: "identifier = %@", id)
    request.predicate = predicate

    let result = try? context.fetch(request)
    if let channel = result?.first {
      return channel
    } else {
      return nil
    }
  }
}
