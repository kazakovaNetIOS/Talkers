//
//  Channel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 21.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

typealias ChannelKeys = Channel.Keys

struct Channel: Equatable {
  let identifier: String
  let name: String
  let lastMessage: String?
  let lastActivity: Date?

  var isEmptyMessage: Bool {
    return self.lastMessage?.count == 0
  }

  public enum Keys {
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let lastActivity = "lastActivity"
  }

  static func == (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.identifier == rhs.identifier
  }
} 
