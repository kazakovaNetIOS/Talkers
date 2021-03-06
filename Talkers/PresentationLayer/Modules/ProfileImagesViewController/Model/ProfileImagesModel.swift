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
  func getCellModel(at position: Int) -> ProfileImagesCellModelProtocol?
  func getNumbersOfObjects() -> Int
  func selectImage(at indexPath: IndexPath)
}

protocol ProfileImagesModelDelegateProtocol: class {
  func downloadImagesDidFinish(_ images: [Hit]?)
  func didImageSelected(with urlString: String?)
  func showError(with message: String)
}

class ProfileImagesModel {
  weak var delegate: ProfileImagesModelDelegateProtocol?
  private var profileImagesService: ProfileImagesServiceProtocol
  private var themesService: ThemesServiceProtocol
  private var images: [Hit]?

  lazy var collectionViewDataSource: ProfileImagesCollectionViewDataSource = {
    return ProfileImagesCollectionViewDataSource(model: self,
                                                 themeSettings: currentThemeSettings)
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
    profileImagesService.loadAvatarList()
  }

  func getNumbersOfObjects() -> Int {
    return self.images?.count ?? 0
  }

  func selectImage(at indexPath: IndexPath) {
    self.delegate?.didImageSelected(with: self.images?[indexPath.row].fullHDURL)
  }

  func getCellModel(at position: Int) -> ProfileImagesCellModelProtocol? {
    guard let hit = images?[position],
          let previewImageUrlString = hit.previewURL,
          let fullHDImageUrlString = hit.fullHDURL else { return nil }

    return ProfileImagesCellModel(previewImageUrlString,
                                  fullHDImageUrlString,
                                  profileImagesService)
  }
}

// MARK: - ProfileImagesServiceDelegateProtocol

extension ProfileImagesModel: ProfileImagesServiceDelegateProtocol {
  func downloadAvatarListDidFinish(images: PixabayImages?) {
    self.images = images?.hits
    self.delegate?.downloadImagesDidFinish(self.images)
  }

  func processError(with message: String) {
    self.delegate?.showError(with: message)
  }
}
