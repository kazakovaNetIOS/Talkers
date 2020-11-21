//
//  ProfileImagesCollectionViewDataSource.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileImagesCollectionViewDataSource: NSObject {
  private let model: ProfileImagesModelProtocol
  private let currentThemeSettings: ThemeSettings
  private let cellIdentifier = String(describing: ProfileImagesCollectionViewCell.self)

  init(model: ProfileImagesModelProtocol,
       themeSettings: ThemeSettings) {
    self.model = model
    self.currentThemeSettings = themeSettings
  }
}

// MARK: - UICollectionViewDataSource

extension ProfileImagesCollectionViewDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.getNumbersOfObjects()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cellModel = self.model.getCellModel(at: indexPath.row)
    let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProfileImagesCollectionViewCell

    cellModel?.delegate = collectionViewCell

    if let cell = collectionViewCell,
       let model = cellModel {
      cell.configure(with: model, themeSettings: currentThemeSettings)
      return cell
    }

    return UICollectionViewCell()
  }
}
