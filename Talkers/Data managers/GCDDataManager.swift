//
//  FileStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class GCDDataManager {
  static let shared = GCDDataManager()

  private var savingCompletionBlock: ((Bool) -> Void) = { isError in
    Logger.printInLog("Execution completed \(isError ? "with" : "no") errors")
  }
  private var loadingCompletionBlock: ((UserProfile?) -> Void) = { userProfile in
    Logger.printInLog("Profile \(userProfile == nil ? "not" : "succesfully") loaded")
  }
  private init() {}

  func saveUserProfile(profile: UserProfile, completion savingDidFinishedWithError: @escaping (_ isError: Bool) -> Void) {
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

private extension GCDDataManager {
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
