//
//  ProfileImagesCellModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 21.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ProfileImagesCellModelProtocol {
  var delegate: ProfileImagesCellModelDelegateProtocol? { get set }
  func loadImage()
}

protocol ProfileImagesCellModelDelegateProtocol: class {
  func downloadImageDidFinished(with image: UIImage?)
}

class ProfileImagesCellModel {
  weak var delegate: ProfileImagesCellModelDelegateProtocol?
  private let previewImageUrlString: String
  private let fullHDImageUrlString: String
  private let profileImagesService: ProfileImagesServiceProtocol

  init(_ previewImageUrlString: String,
       _ fullHDImageUrlString: String,
       _ service: ProfileImagesServiceProtocol) {
    self.previewImageUrlString = previewImageUrlString
    self.fullHDImageUrlString = fullHDImageUrlString
    self.profileImagesService = service
  }
}

// MARK: - ProfileImagesCellModelProtocol

extension ProfileImagesCellModel: ProfileImagesCellModelProtocol {
  func loadImage() {
    self.profileImagesService.loadImage(by: self.previewImageUrlString) { (result) in
      switch result {
      case .success(let image):
        self.delegate?.downloadImageDidFinished(with: image)
      case _:
        self.delegate?.downloadImageDidFinished(with: UIImage(named: "broken_image"))
      }
    }
  }
}
