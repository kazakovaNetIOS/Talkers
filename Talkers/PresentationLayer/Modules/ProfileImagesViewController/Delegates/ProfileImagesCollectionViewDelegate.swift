//
//  ProfileImagesCollectionViewDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileImagesCollectionViewDelegate: NSObject {
  private let model: ProfileImagesModelProtocol

  init(model: ProfileImagesModelProtocol) {
    self.model = model
  }
}

// MARK: - UICollectionViewDelegate

extension ProfileImagesCollectionViewDelegate: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    model.selectImage(at: indexPath)
  }
}
