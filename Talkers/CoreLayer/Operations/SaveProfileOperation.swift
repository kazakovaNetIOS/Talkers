//
//  SaveProfileOperation.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class SaveProfileOperation: AsyncOperation {
  var profile: Profile
  var isError = false
  private var fileStorage: FileStorageProtocol

  init(profile: Profile,
       fileStorage: FileStorageProtocol) {
    self.profile = profile
    self.fileStorage = fileStorage
  }

  override func main() {
    do {
      try fileStorage.saveToFile(profile: profile)
    } catch {
      isError = true
    }
    finish()
  }
}
