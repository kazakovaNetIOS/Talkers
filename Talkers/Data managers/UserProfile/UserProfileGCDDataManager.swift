//
//  FileStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class UserProfileGCDDataManager {
  private var savingCompletionBlock: ((Bool) -> Void) = { _ in }
  private var loadingCompletionBlock: ((UserProfile?) -> Void) = { _ in }
}

// MARK: - UserProfileManager

extension UserProfileGCDDataManager: UserProfileManager {
  func saveUserProfile(
    profile: UserProfile,
    completion savingDidFinishedWithError: @escaping (_ isError: Bool) -> Void) {
    savingCompletionBlock = savingDidFinishedWithError

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        try FileStorage.shared.saveToFile(userProfile: profile)
        self?.processSavingResult(isError: false)
      } catch {
        self?.processSavingResult(isError: true)
      }
    }
  }

  func loadUserProfile(completion loadingDidFinished: @escaping (_ userProfile: UserProfile?) -> Void) {
    loadingCompletionBlock = loadingDidFinished

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        let profile = try FileStorage.shared.loadFromFile()
        self?.processLoadingResult(userProfile: profile)
      } catch {
        self?.processLoadingResult(userProfile: nil)
      }
    }
  }
}

// MARK: - Private

private extension UserProfileGCDDataManager {
  func processSavingResult(isError: Bool) {
    DispatchQueue.main.async { [weak self] in
      self?.savingCompletionBlock(isError)
    }
  }

  func processLoadingResult(userProfile: UserProfile?) {
    DispatchQueue.main.async { [weak self] in
      self?.loadingCompletionBlock(userProfile)
    }
  }
}
