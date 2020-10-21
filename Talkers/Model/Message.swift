//
//  Message.swift
//  Talkers
//
//  Created by Natalia Kazakova on 21.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

struct Message: Equatable {
  let content: String
  let created: Date
  let senderId: String
  let senderName: String

  func asDictionary() -> [String: Any] {
    return [
      "content": content,
      "created": Timestamp(date: created),
      "senderId": senderId,
      "senderName": senderName]
  }
} 
