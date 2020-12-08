//
//  FileStorageMock.swift
//  TalkersTests
//
//  Created by Natalia Kazakova on 03.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

@testable import Talkers

class FileStorageMock {
  var callsCount: Int = 0
  var receivedProfilePosition: String?
}

// MARK: - FileStorageProtocol

extension FileStorageMock: FileStorageProtocol {
  func saveToFile(profile: Profile) throws {
    callsCount += 1
    receivedProfilePosition = profile.position
  }

  func loadFromFile() throws -> Profile? {
    fatalError("Need to implement!")
  }
}
