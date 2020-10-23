//
//  LoadUserProfileOperation.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class SaveUserProfileOperation: AsyncOperation {
  var userProfile: UserProfile
  var isError = false

  init(userProfile: UserProfile) {
    self.userProfile = userProfile
  }

  override func execute() {
    do {
      try FileStorage.shared.saveToFile(userProfile: userProfile)
    } catch {
      isError = true
    }
  }
}
