//
//  LoadUserProfileOperation.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class SaveProfileOperation: AsyncOperation {
  var userProfile: Profile
  var isError = false
  private var fileStorage: FileStorageProtocol

  init(userProfile: Profile,
       fileStorage: FileStorageProtocol) {
    self.userProfile = userProfile
    self.fileStorage = fileStorage
  }

  override func main() {
    do {
      try fileStorage.saveToFile(profile: userProfile)
    } catch {
      isError = true
    }
    finish()
  }
}
