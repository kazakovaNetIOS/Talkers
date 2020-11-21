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
  let imageUrlString: String
  private let profileImagesService: ProfileImagesServiceProtocol

  init(_ imageUrlString: String, service: ProfileImagesServiceProtocol) {
    self.imageUrlString = imageUrlString
    self.profileImagesService = service
  }
}

// MARK: - ProfileImagesCellModelProtocol

extension ProfileImagesCellModel: ProfileImagesCellModelProtocol {
  func loadImage() {
    self.profileImagesService.loadImage(by: self.imageUrlString) { (result) in
      switch result {
      case .success(let image):
        self.delegate?.downloadImageDidFinished(with: image)
      case _:
        // todo error image
        self.delegate?.downloadImageDidFinished(with: UIImage(named: "download"))
      }
    }
  }
}
