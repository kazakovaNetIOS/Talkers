//
//  Channel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 21.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

struct Channel: Equatable {
  let identifier: String
  let name: String
  let lastMessage: String?
  let lastActivity: Date?

  var isEmptyMessage: Bool {
    return self.lastMessage?.count == 0
  }
} 
