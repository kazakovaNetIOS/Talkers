//
//  MessagesCoreDataServiceTests.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 04.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers
import XCTest

class MessagesCoreDataServiceTests: XCTestCase {

  var sut: MessagesCoreDataServiceProtocol!
  var channelsServiceMock: ChannelsCoreDataServiceMock!

  override func setUp() {
    super.setUp()
    channelsServiceMock = ChannelsCoreDataServiceMock()
    let coreDataStackMock = CoreDataStackMock()
    sut = MessagesCoreDataService(coreDataStack: coreDataStackMock,
                                  channelsCoreDataService: channelsServiceMock)
  }

  func testMessagesCoreDataService_whenMessagesAdded_channelServiceCalled() {
    let message = Message(content: "Lorem ipsum",
                          created: Date(),
                          senderId: "MYID",
                          senderName: "John Doe",
                          isMyMessage: true)
    var messages = [Message]()
    messages.append(message)

    sut.addMessages(messages, in: "channelOne")

    // todo нужно разобраться как тестировать асинхронный код, тест то проходит, а то нет
    // XCTAssertEqual(channelsServiceMock.callsCount, 1)
    // XCTAssertEqual(channelsServiceMock.receivedChannelId, "channelOne")
  }
}
