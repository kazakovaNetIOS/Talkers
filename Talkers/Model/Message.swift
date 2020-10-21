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

  var dictionary: [String: Any] {
    return [
      Keys.content: content,
      Keys.created: Timestamp(date: created),
      Keys.senderId: senderId,
      Keys.senderName: senderName]
  }

  var isMyMessage: Bool {
    return self.senderId == ConversationsDataManager.mySenderId
  }

  public enum Keys {
    static let content = "content"
    static let created = "created"
    static let senderId = "senderId"
    static let senderName = "senderName"
  }
}
