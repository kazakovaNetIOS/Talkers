//
//  ProfileOperationService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 14.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ProfileOperationServiceProtocol {
  var delegate: ProfileServiceDelegateProtocol? { get set }
  func saveProfile(profile: Profile)
  func loadProfile()
}

class ProfileOperationService {
  weak var delegate: ProfileServiceDelegateProtocol?
  private var fileStorage: FileStorageProtocol

  init(fileStorage: FileStorageProtocol) {
    self.fileStorage = fileStorage
  }
}

// MARK: - ProfileOperationServiceProtocol

extension ProfileOperationService: ProfileOperationServiceProtocol {
  func saveProfile(profile: Profile) {
    let operation = SaveProfileOperation(profile: profile, fileStorage: fileStorage)
    operation.completionBlock = {[weak self] in
      OperationQueue.main.addOperation {
        if operation.isError {
          self?.delegate?.processError(with: "Error while saving user profile")
        } else {
          self?.delegate?.savingDidFinish()
        }
      }
    }
    OperationQueue().addOperation(operation)
  }

  func loadProfile() {
    let operation = LoadProfileOperation(fileStorage: fileStorage)
    operation.completionBlock = {[weak self] in
      OperationQueue.main.addOperation {
        if let profile = operation.profile {
          self?.delegate?.loadingDidFinish(profile)
        } else {
          self?.delegate?.processError(with: "Error while loading user profile")
        }
      }
    }
    OperationQueue().addOperation(operation)
  }
}
