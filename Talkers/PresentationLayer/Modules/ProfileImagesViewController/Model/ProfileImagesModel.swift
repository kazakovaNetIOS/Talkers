//
//  ProfileImagesModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ProfileImagesModelProtocol {
  var delegate: ProfileImagesModelDelegateProtocol? { get set }
  var collectionViewDataSource: ProfileImagesCollectionViewDataSource { get }
  var collectionViewDelegate: ProfileImagesCollectionViewDelegate { get }
  var currentThemeSettings: ThemeSettings { get }

  func fetchImages()
  func getImage(at position: Int) -> Hit?
  func getNumbersOfObjects() -> Int
  func selectImage(at indexPath: IndexPath)
}

protocol ProfileImagesModelDelegateProtocol: class {
  func downloadImagesDidFinish(_ images: [Hit]?)
  func showError(with message: String)
}

class ProfileImagesModel {
  weak var delegate: ProfileImagesModelDelegateProtocol?
  private var profileImagesService: ProfileImagesServiceProtocol
  private var themesService: ThemesServiceProtocol
  private var images: [Hit]? = [Hit]()

  lazy var collectionViewDataSource: ProfileImagesCollectionViewDataSource = {
    return ProfileImagesCollectionViewDataSource(model: self)
  }()
  lazy var collectionViewDelegate: ProfileImagesCollectionViewDelegate = {
    return ProfileImagesCollectionViewDelegate(model: self)
  }()
  var currentThemeSettings: ThemeSettings {
    return themesService.currentThemeSettings
  }

  init(profileImagesService: ProfileImagesServiceProtocol,
       themesService: ThemesServiceProtocol) {
    self.profileImagesService = profileImagesService
    self.themesService = themesService
    self.profileImagesService.delegate = self
  }
}

// MARK: - ProfileImagesModelProtocol

extension ProfileImagesModel: ProfileImagesModelProtocol {
  func fetchImages() {
    profileImagesService.getAvatarList()
  }

  func getNumbersOfObjects() -> Int {
    return self.images?.count ?? 0
  }

  func selectImage(at indexPath: IndexPath) {
    // todo
  }

  func getImage(at position: Int) -> Hit? {
    return images?[position]
  }
}

// MARK: - ProfileImagesServiceDelegateProtocol

extension ProfileImagesModel: ProfileImagesServiceDelegateProtocol {
  func downloadImagesDidFinish(images: PixabayImages?) {
    self.images = images?.hits
    self.delegate?.downloadImagesDidFinish(self.images)
  }

  func processError(with message: String) {
    self.delegate?.showError(with: message)
  }
}
