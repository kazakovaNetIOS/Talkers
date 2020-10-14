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

  func saveToFile(profile: UserProfile, completion savingDidFinishedWithError: @escaping (_ isError: Bool) -> Void) {
    guard let path = UserProfile.ArchiveURL else {
      processSavingResult(isError: true)
      return
    }

    savingCompletionBlock = savingDidFinishedWithError

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: profile, requiringSecureCoding: false)
        try data.write(to: path)
      } catch {
        self?.processSavingResult(isError: true)
      }

      self?.processSavingResult(isError: false)
    }
  }

  func loadFromFile(completion loadingDidFinished: @escaping (_ userProfile: UserProfile?) -> Void) {
    guard let path = UserProfile.ArchiveURL else {
      return
    }

    loadingCompletionBlock = loadingDidFinished

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        let data = try Data(contentsOf: path)
        let profile = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserProfile
        self?.processLoadingResult(userProfile: profile)
      } catch {
        return
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
