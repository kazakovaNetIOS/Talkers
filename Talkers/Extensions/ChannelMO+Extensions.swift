//
//  ChannelMO+Extensions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 31.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

extension ChannelMO {
  convenience init(with channel: Channel, in context: NSManagedObjectContext) {
    self.init(context: context)

    self.identifier = channel.identifier
    self.name = channel.name
    self.lastMessage = channel.lastMessage
    self.lastActivity = channel.lastActivity
  }
}
