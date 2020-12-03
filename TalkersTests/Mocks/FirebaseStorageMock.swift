//
//  FirebaseStorageMock.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 02.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
@testable import Talkers

class FirebaseStorageMock {
  var callsCount: Int = 0
  var receivedNewChannelName: String?
  var receivedChannelId: String?
}

extension FirebaseStorageMock: FirebaseStorageProtocol {
  func addChannel(with data: [String: String]) {
    callsCount += 1
    receivedNewChannelName = data["name"]
  }

  func addMessage(in channelId: String, with data: [String: Any]) {
    callsCount += 1
    receivedChannelId = channelId
  }

  func deleteChannel(with id: String, completion: @escaping (Error?) -> Void) {

  }

  func addChannelChangesListener(_ listener: @escaping (Result<[Channel], Error>) -> Void) {

  }

  func addMessagesChangesListener(in channelId: String,
                                  with mySenderId: String,
                                  _ listener: @escaping (Result<[Message], Error>) -> Void) {

  }
}
