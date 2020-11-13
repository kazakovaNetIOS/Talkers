//
//  ChatRequest.swift
//  Talkers
//
//  Created by Natalia Kazakova on 29.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

struct MessagesRequest {
  let coreDataStack: CoreDataStack

  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }

  func makeRequest(messages: [Message], in channel: ChannelMO) {
    messages.forEach { message in
      _ = MessageMO(with: message, channel: channel, in: coreDataStack.managedContext)
      coreDataStack.saveContext()
    }
  }
}
