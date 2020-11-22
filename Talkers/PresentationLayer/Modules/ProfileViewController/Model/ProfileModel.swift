//
//  ProfileModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ProfileModelProtocol {
  var delegate: ProfileModelDelegateProtocol? { get set }
  var currentThemeSettings: ThemeSettings { get }

  func useGCDServiceType()
  func useOperationServiceType()
  func loadProfile()
  func saveProfile(_ profile: Profile)
  func loadProfileImage(by urlString: String, completion: @escaping (Result<UIImage?, DownloadingImagesError>) -> Void)
}

protocol ProfileModelDelegateProtocol: class {
  func profileDidLoaded(_ profile: Profile?)
  func savingDidFinish()
  func showError(with message: String)
}

class ProfileModel {
  weak var delegate: ProfileModelDelegateProtocol?
  private var profileService: ProfileServiceProtocol
  private var themesService: ThemesServiceProtocol
  private var profileImagesService: ProfileImagesServiceProtocol

  var currentThemeSettings: ThemeSettings {
    return themesService.currentThemeSettings
  }

  init(profileService: ProfileServiceProtocol,
       themesService: ThemesServiceProtocol,
       profileImagesService: ProfileImagesServiceProtocol) {
    self.profileService = profileService
    self.themesService = themesService
    self.profileImagesService = profileImagesService
    self.profileService.delegate = self
  }
}

// MARK: - ProfileModelProtocol

extension ProfileModel: ProfileModelProtocol {
  func saveProfile(_ profile: Profile) {
    profileService.saveProfile(profile)
  }

  func loadProfile() {
    profileService.loadProfile()
  }

  func useGCDServiceType() {
    profileService.useServiceType(.gcd)
  }

  func useOperationServiceType() {
    profileService.useServiceType(.operation)
  }

  func loadProfileImage(by urlString: String, completion: @escaping (Result<UIImage?, DownloadingImagesError>) -> Void) {
    profileImagesService.loadImage(by: urlString, completion: completion)
  }
}

// MARK: - ProfileServiceDelegateProtocol

extension ProfileModel: ProfileServiceDelegateProtocol {
  func loadingDidFinish(_ profile: Profile?) {
    self.delegate?.profileDidLoaded(profile)
  }

  func savingDidFinish() {
    self.delegate?.savingDidFinish()
  }

  func processError(with message: String) {
    self.delegate?.showError(with: message)
  }
}
