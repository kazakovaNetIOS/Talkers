//
//  UserProfileService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol UserProfileServiceProtocol {
  func getSenderId() -> String
  func getUserProfile() -> UserProfile
}

class UserProfileService {
  private var dataManager: UserProfileManager

  init(dataManager: UserProfileManager) {
    self.dataManager = dataManager
  }
}

// MARK: - UserProfileServiceProtocol

extension UserProfileService: UserProfileServiceProtocol {
  func getSenderId() -> String {
    if let storedSenderId = UserDefaults.standard.string(forKey: MessageKeys.senderId) {
      return storedSenderId
    } else {
      let id = UUID().uuidString
      UserDefaults.standard.setValue(id, forKey: MessageKeys.senderId)
      return id
    }
  }

  func getUserProfile() -> UserProfile {
//    dataManager.loadUserProfile { userProfile in
//      return userProfile
//    }
    // todo
    return UserProfile(name: "Natalia Kazakova", position: "IOS developer", avatar: nil)
  }
}
