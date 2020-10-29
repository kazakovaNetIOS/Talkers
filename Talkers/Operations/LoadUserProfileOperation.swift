//
//  SaveUserProfileOperation.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class LoadUserProfileOperation: AsyncOperation {
  var userProfile: UserProfile?

  override func main() {
    do {
      userProfile = try FileStorage.shared.loadFromFile()
    } catch {
      userProfile = nil
    }
    finish()
  }
}
