//
//  ProfileService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ProfileServiceProtocol {
  var delegate: ProfileServiceDelegateProtocol? { get set }
  func getSenderId() -> String
  func useServiceType(_ type: BackgroundMethod)
  func loadProfile()
  func loadProfile(_ completion: @escaping (Result<Profile, ProfileGCDError>) -> Void)
  func saveProfile(_ profile: Profile)
}

protocol ProfileServiceDelegateProtocol: class {
  func loadingDidFinish(_ profile: Profile?)
  func savingDidFinish()
  func processError(with message: String)
}

class ProfileService {
  weak var delegate: ProfileServiceDelegateProtocol?
  private var profileGSDService: ProfileGCDServiceProtocol
  private var profileOperationService: ProfileOperationServiceProtocol
  private var serviceType: BackgroundMethod?

  init(profileGSDService: ProfileGCDServiceProtocol,
       profileOperationService: ProfileOperationServiceProtocol) {
    self.profileGSDService = profileGSDService
    self.profileOperationService = profileOperationService
    self.profileGSDService.delegate = self
    self.profileOperationService.delegate = self
  }
}

// MARK: - ProfileServiceProtocol

extension ProfileService: ProfileServiceProtocol {
  func saveProfile(_ profile: Profile) {
    switch self.serviceType {
    case .gcd:
      profileGSDService.saveProfile(profile: profile)
    case .operation:
      profileOperationService.saveProfile(profile: profile)
    case .none:
      return
    }
  }

  func loadProfile() {
    switch self.serviceType {
    case .gcd:
      profileGSDService.loadProfile()
    case .operation:
      profileOperationService.loadProfile()
    case .none:
      return
    }
  }

  func loadProfile(_ completion: @escaping (Result<Profile, ProfileGCDError>) -> Void) {
    profileGSDService.loadProfile(completion)
  }

  func getSenderId() -> String {
    if let storedSenderId = UserDefaults.standard.string(forKey: MessageKeys.senderId) {
      return storedSenderId
    } else {
      let id = UUID().uuidString
      UserDefaults.standard.setValue(id, forKey: MessageKeys.senderId)
      return id
    }
  }

  func useServiceType(_ type: BackgroundMethod) {
    self.serviceType = type
  }
}

// MARK: - ProfileServiceDelegateProtocol

extension ProfileService: ProfileServiceDelegateProtocol {
  func savingDidFinish() {
    self.delegate?.savingDidFinish()
  }

  func processError(with message: String) {
    self.delegate?.processError(with: message)
  }
  
  func loadingDidFinish(_ profile: Profile?) {
    self.delegate?.loadingDidFinish(profile)
  }
}
