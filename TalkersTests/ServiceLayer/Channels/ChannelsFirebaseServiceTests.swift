//
//  ChannelsFirebaseServiceTests.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 01.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers
import XCTest

class ChannelsFirebaseServiceTests: XCTestCase {

  var sut: ChannelsFirebaseServiceProtocol!
  var storageMock: FirebaseStorageMock!

  override func setUp() {
    super.setUp()
    storageMock = FirebaseStorageMock()
    sut = ChannelsFirebaseService(firebaseStorage: storageMock)
  }

  func testChannelsFirebaseService_whenChannelAdded_storageCalled() {
    sut.addChannel(withName: "New channel")

    XCTAssertEqual(storageMock.callsCount, 1)
    XCTAssertEqual(storageMock.receivedNewChannelName, "New channel")
  }
}
