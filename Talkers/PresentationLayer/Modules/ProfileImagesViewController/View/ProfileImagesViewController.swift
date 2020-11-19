//
//  DownloadViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 18.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileImagesViewController: UIViewController {
  var model: ProfileImagesModelProtocol?

  @IBOutlet weak var collection: UICollectionView!
  @IBOutlet weak var collectionActivityIndicator: UIActivityIndicatorView!
}

// MARK: - Life cycle
extension ProfileImagesViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    configureCollectionView()
    model?.fetchImages()
  }
}

// MARK: - ProfileImagesModelDelegateProtocol

extension ProfileImagesViewController: ProfileImagesModelDelegateProtocol {
  func downloadImagesDidFinish(_ images: [Hit]?) {
    guard let images = images else { return }

    collection.isHidden = images.isEmpty
    collection.reloadData()

    if !images.isEmpty {
      collectionActivityIndicator.stopAnimating()
    }
  }

  func showError(with message: String) {
    // todo
    print(message)
  }
}

// MARK: - IBActions

extension ProfileImagesViewController {
  @IBAction func closeButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

private extension ProfileImagesViewController {
  func configureCollectionView() {
    collection.delegate = model?.collectionViewDelegate
    collection.dataSource = model?.collectionViewDataSource
  }
}

// MARK: - Instantiation from storybord

extension ProfileImagesViewController {
  static func storyboardInstance() -> ProfileImagesViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? ProfileImagesViewController
  }
}
