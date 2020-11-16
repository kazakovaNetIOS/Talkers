//
//  FileStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol FileStorageProtocol {
  func saveToFile(profile: Profile) throws
  func loadFromFile() throws -> Profile?
}

class FileStorage {
  enum FileStorageError: Error {
    case runtimeError
  }
}

// MARK: - FileStorageProtocol

extension FileStorage: FileStorageProtocol {
  func saveToFile(profile: Profile) throws {
    guard let path = Profile.ArchiveURL else { throw FileStorageError.runtimeError }

    let data = try NSKeyedArchiver.archivedData(withRootObject: profile, requiringSecureCoding: false)
    try data.write(to: path)
  }

  func loadFromFile() throws -> Profile? {
    guard let url = Profile.ArchiveURL else { throw FileStorageError.runtimeError }

    if FileManager.default.fileExists(atPath: url.path) {
      let data = try Data(contentsOf: url)
      return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Profile
    }

    return nil
  }
}

private extension FileStorage {
  func checkFile(url: URL) {

  }
}
