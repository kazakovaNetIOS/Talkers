//
//  OperationDataManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 14.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class OperationDataManager {
  static let shared = OperationDataManager()

  private init() {}

  func saveToFile(profile: UserProfile, completion savingDidFinishedWithError: @escaping (_ isError: Bool) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      savingDidFinishedWithError(false)
    }
  }

  func loadFromFile(completion loadingDidFinished: @escaping (_ userProfile: UserProfile?) -> Void) {
    loadingDidFinished(UserProfile(name: "Ivan Ivanov", position: "IOS-developer", avatar: nil))
  }
}
