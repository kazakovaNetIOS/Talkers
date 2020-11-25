//
//  Message.swift
//  Talkers
//
//  Created by Natalia Kazakova on 21.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

typealias MessageKeys = Message.Keys

struct Message: Equatable {
  let content: String
  let created: Date
  let senderId: String
  let senderName: String
  let isMyMessage: Bool

  var dictionary: [String: Any] {
    return [
      Keys.content: content,
      Keys.created: Timestamp(date: created),
      Keys.senderId: senderId,
      Keys.senderName: senderName]
  }

  public enum Keys {
    static let content = "content"
    static let created = "created"
    static let senderId = "senderId"
    static let senderName = "senderName"
  }

  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.senderId == rhs.senderId &&
      lhs.created == rhs.created
  }
}

// MARK: - Init from ChannelMO

extension Message {
  init(_ messageMO: MessageMO, isMyMessage: Bool) {
    self.content = messageMO.content ?? ""
    self.created = messageMO.created ?? .distantPast
    self.senderId = messageMO.senderId ?? ""
    self.senderName = messageMO.senderName ?? ""
    self.isMyMessage = isMyMessage
  }
}
