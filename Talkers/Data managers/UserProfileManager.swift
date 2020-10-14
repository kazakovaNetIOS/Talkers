//
//  UserProfileManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol UserProfileManager {
  func saveUserProfile(profile: UserProfile, completion savingDidFinishedWithError: @escaping (_ isError: Bool) -> Void)
  func loadUserProfile(completion loadingDidFinished: @escaping (_ userProfile: UserProfile?) -> Void)
}

enum BackgroundMethod {
  case gcd, operation
}

class DataManager {
  private var dataManager: UserProfileManager
  var managerType: BackgroundMethod = .gcd {
    didSet {
      switch managerType {
      case .gcd:
        dataManager = GCDDataManager()
      case .operation:
        dataManager = OperationDataManager()
      }
    }
  }

  init() {
    switch managerType {
    case .gcd:
      dataManager = GCDDataManager()
    case .operation:
      dataManager = OperationDataManager()
    }
  }

  func save(profile: UserProfile, completion: @escaping (Bool) -> Void) {
    dataManager.saveUserProfile(profile: profile, completion: completion)
  }

  func load(completion: @escaping (UserProfile?) -> Void) {
    dataManager.loadUserProfile(completion: completion)
  }
}
