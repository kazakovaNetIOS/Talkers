//
//  ProfileImagesCollectionViewCell.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileImagesCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = UIImage(named: "image")
  }
}

// MARK: - ConfigurableView

extension ProfileImagesCollectionViewCell: ConfigurableView {
  typealias ConfigurationModel = ProfileImagesCellModelProtocol

  func configure(with model: ConfigurationModel, themeSettings: ThemeSettings) {
    activityIndicator.startAnimating()
    model.loadImage()
    changeColorsForTheme(with: themeSettings)
  }
}

// MARK: - ProfileImagesCellModelDelegateProtocol

extension ProfileImagesCollectionViewCell: ProfileImagesCellModelDelegateProtocol {
  func downloadImageDidFinished(with image: UIImage?) {
    // todo error image
    imageView.image = image != nil ? image : UIImage(named: "download")
    activityIndicator.stopAnimating()
  }
}

// MARK: - Private

private extension ProfileImagesCollectionViewCell {
  func changeColorsForTheme(with settings: ThemeSettings) {

  }
}
