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

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let totalwidth = collectionView.bounds.size.width - 16
    let numberOfCellsPerRow = 3
    let oddEven = indexPath.row / numberOfCellsPerRow % 2
    let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
    if oddEven == 0 {
      return CGSize(width: dimensions, height: dimensions)
    } else {
      return CGSize(width: dimensions, height: dimensions / 2)
    }
  }
}
