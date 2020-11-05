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
  let coreDataStack = CoreDataStack(modelName: "Chats")

  func makeRequest(messages: [Message]) {
    messages.forEach { message in
      _ = MessageMO(with: message, in: coreDataStack.managedContext)
      coreDataStack.saveContext()
    }
  }
}
