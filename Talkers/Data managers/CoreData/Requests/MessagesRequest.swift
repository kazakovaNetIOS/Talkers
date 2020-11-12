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
  let coreDataStack = CoreDataStack()

  func makeRequest(messages: [Message], in channelId: String) {
    messages.forEach { message in
      _ = MessageMO(with: message, channelId: channelId, in: coreDataStack.managedContext)
      coreDataStack.saveContext()
    }
  }
}
