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

  func makeRequest(messages: [Message]) {
    coreDataStack.performSave { context in
      for message in messages {
        setValues(MessageMO(context: context), with: message)
      }
    }
  }
}

// MARK: - Set values by ChannelMO object

extension MessagesRequest {
  private func setValues(_ moMessage: MessageMO, with message: Message) {
    moMessage.content = message.content
    moMessage.created = message.created
    moMessage.senderId = message.senderId
    moMessage.senderName = message.senderName
  }
}
