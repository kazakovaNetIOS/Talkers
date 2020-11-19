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
  private let cellIdentifier = String(describing: ProfileImagesCollectionViewCell.self)

  init(model: ProfileImagesModelProtocol) {
    self.model = model
  }
}

// MARK: - UICollectionViewDataSource

extension ProfileImagesCollectionViewDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.getNumbersOfObjects()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let hit = self.model.getImage(at: indexPath.row),
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProfileImagesCollectionViewCell else {
      return UICollectionViewCell()
    }

    cell.configure(with: hit, themeSettings: model.currentThemeSettings)
    
    return cell
  }
}
