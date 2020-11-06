//
//  MessageMO+Extensions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 01.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

extension MessageMO {
  convenience init(with message: Message, channelId: String, in context: NSManagedObjectContext) {
    self.init(context: context)

    self.channel = CoreDataManager().getChannel(by: channelId)
    self.content = message.content
    self.created = message.created
    self.senderId = message.senderId
    self.senderName = message.senderName
  }
}
