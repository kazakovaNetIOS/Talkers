//
//  ProfileGCDService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ProfileGCDServiceProtocol {
  var delegate: ProfileServiceDelegateProtocol? { get set }
  func saveProfile(profile: Profile)
  func loadProfile()
  func loadProfile(_ completion: @escaping (Result<Profile, ProfileGCDError>) -> Void)
}

enum ProfileGCDError: Error {
  case profileNotLoad
}

class ProfileGCDService {
  weak var delegate: ProfileServiceDelegateProtocol?
  private var fileStorage: FileStorageProtocol

  init(fileStorage: FileStorageProtocol) {
    self.fileStorage = fileStorage
  }
}

// MARK: - ProfileGCDServiceProtocol

extension ProfileGCDService: ProfileGCDServiceProtocol {
  func saveProfile(profile: Profile) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        try self?.fileStorage.saveToFile(profile: profile)
      } catch {
        self?.performInMainThread { [weak self] in
          self?.delegate?.processError(with: "Error while saving user profile")
        }
      }

      self?.performInMainThread { [weak self] in
        self?.delegate?.savingDidFinish()
      }
    }
  }

  func loadProfile() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        let profile = try self?.fileStorage.loadFromFile()
        self?.performInMainThread { [weak self] in
          self?.delegate?.loadingDidFinish(profile)
        }
      } catch {
        self?.performInMainThread { [weak self] in
          self?.delegate?.processError(with: "Error while loading user profile, \(error.localizedDescription)")
        }
      }
    }
  }

  func loadProfile(_ completion: @escaping (Result<Profile, ProfileGCDError>) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        if let profile = try self?.fileStorage.loadFromFile() {
          self?.performInMainThread { completion(.success(profile)) }
        } else {
          self?.performInMainThread { completion(.failure(.profileNotLoad)) }
        }
      } catch {
        self?.performInMainThread { completion(.failure(.profileNotLoad)) }
      }
    }
  }
}

// MARK: - Private

private extension ProfileGCDService {
  func performInMainThread(block: @escaping () -> Void) {
    DispatchQueue.main.async {
      block()
    }
  }
}
