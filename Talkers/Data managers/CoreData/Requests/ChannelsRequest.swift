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
  let coreDataStack = CoreDataStack.share

  func makeRequest(channels: [Channel]) {
    channels.forEach { channel in
      _ = ChannelMO(with: channel, in: coreDataStack.managedContext)
      coreDataStack.saveContext()
    }
  }
}
