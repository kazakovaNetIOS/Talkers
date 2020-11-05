//
//  ChatRequest.swift
//  Talkers
//
//  Created by Natalia Kazakova on 29.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

struct ChannelsRequest {
  let coreDataStack: CoreDataStack

  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }

  func makeRequest(channels: [Channel]) {
    coreDataStack.performSave { context in
      channels.forEach { ChannelMO(with: $0, in: context) }
    }
  }
}
