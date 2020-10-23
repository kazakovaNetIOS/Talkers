//
//  FileStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class FileStorage {
  enum FileStorageError: Error {
    case runtimeError
  }

  static let shared = FileStorage()

  private init() {}

  func saveToFile(userProfile: UserProfile) throws {
    guard let path = UserProfile.ArchiveURL else {
      throw FileStorageError.runtimeError
    }

    let data = try NSKeyedArchiver.archivedData(withRootObject: userProfile, requiringSecureCoding: false)
    try data.write(to: path)
  }

  func loadFromFile() throws -> UserProfile? {
    guard let path = UserProfile.ArchiveURL else {
      throw FileStorageError.runtimeError
    }

    let data = try Data(contentsOf: path)
    return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserProfile
  }
}
