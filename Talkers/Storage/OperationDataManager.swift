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
    let operation = SaveUserProfileOperation(userProfile: profile)
    operation.completionBlock = {
      OperationQueue.main.addOperation {
        savingDidFinishedWithError(operation.isError)
      }
    }
    OperationQueue().addOperation(operation)
  }

  func loadFromFile(completion loadingDidFinished: @escaping (_ userProfile: UserProfile?) -> Void) {
    let operation = LoadUserProfileOperation()
    operation.completionBlock = {
      OperationQueue.main.addOperation {
        loadingDidFinished(operation.userProfile)
      }
    }
    OperationQueue().addOperation(operation)
  }
}
