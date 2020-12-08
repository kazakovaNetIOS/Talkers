//
//  MessagesFirebaseServiceTests.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 04.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers
import XCTest

class MessagesFirebaseServiceTests: XCTestCase {

  var sut: MessagesFirebaseServiceProtocol!
  var storageMock: FirebaseStorageMock!

  override func setUp() {
    super.setUp()
    storageMock = FirebaseStorageMock()
    sut = MessagesFirebaseService(firebaseStorage: storageMock)
  }

  func testMessagesFirebaseService_whenMessageAdded_storageCalled() {
    let message = Message(content: "Lorem ipsum",
                          created: Date(),
                          senderId: "MYID",
                          senderName: "John Doe",
                          isMyMessage: true)
    sut.addMessage(with: message, in: "channelOne")

    XCTAssertEqual(storageMock.callsCount, 1)
    XCTAssertEqual(storageMock.receivedChannelId, "channelOne")
  }
}
