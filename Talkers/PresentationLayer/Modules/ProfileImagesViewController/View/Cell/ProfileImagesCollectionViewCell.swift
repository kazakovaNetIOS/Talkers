//
//  ProfileImagesCollectionViewCell.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileImagesCollectionViewCell: UICollectionViewCell {
  var model: Hit?
}

// MARK: - ConfigurableView

extension ProfileImagesCollectionViewCell: ConfigurableView {
  typealias ConfigurationModel = Hit

  func configure(with model: Hit, themeSettings: ThemeSettings) {
    changeColorsForTheme(with: themeSettings)
  }
}

// MARK: - Private

private extension ProfileImagesCollectionViewCell {
  func changeColorsForTheme(with settings: ThemeSettings) {

  }
}
