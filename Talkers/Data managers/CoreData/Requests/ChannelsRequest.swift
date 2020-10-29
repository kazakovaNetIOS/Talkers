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
      for channel in channels {
        setValues(ChannelMO(context: context), with: channel)
      }
    }
  }
}

// MARK: - Set values by ChannelMO object

extension ChannelsRequest {
  private func setValues(_ moChannel: ChannelMO, with channel: Channel) {
    moChannel.identifier = channel.identifier
    moChannel.name = channel.name
    moChannel.lastMessage = channel.lastMessage
    moChannel.lastActivity = channel.lastActivity
  }
}
