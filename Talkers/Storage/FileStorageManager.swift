//
//  FileStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

struct UserProfile {
  let name: String
  let position: String
  let avatar: UIImage
}

class FileStorageManager {
  static let shared = FileStorageManager()

  private init() {}

  func saveToFileWithGCD(profile: UserProfile, completion block: @escaping (_ isError: Bool) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      sleep(2)
      block(true)
    }
  }

  func saveToFileWithOperation(profile: UserProfile, completion block: @escaping (_ isError: Bool) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      sleep(5)
      block(false)
    }
  }
}
