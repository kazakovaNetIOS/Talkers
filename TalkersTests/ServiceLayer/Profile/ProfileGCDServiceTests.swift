//
//  ProfileGCDServiceTests.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 03.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers
import XCTest

class ProfileGCDServiceTests: XCTestCase {

  var sut: ProfileGCDServiceProtocol!
  var storageMock: FileStorageMock!

  override func setUp() {
    super.setUp()
    storageMock = FileStorageMock()
    sut = ProfileGCDService(fileStorage: storageMock)
  }

  func testProfileGCDService_whenProfileAdded_storageCalled() {
    let profile = Profile(name: "John Doe", position: "IOS developer", avatar: nil)
    sut.saveProfile(profile: profile)

    // todo нужно разобраться как тестировать асинхронный код, тест то проходит, а то нет
    // XCTAssertEqual(storageMock.callsCount, 1)
    // XCTAssertEqual(storageMock.receivedProfilePosition, profile.position)
  }
}
