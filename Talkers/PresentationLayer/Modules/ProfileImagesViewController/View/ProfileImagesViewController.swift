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
  var imageDidSelected: ((String) -> Void)?

  private let cellIdentifier = String(describing: ProfileImagesCollectionViewCell.self)

  @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
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
  func didImageSelected(with urlString: String?) {
    guard let urlString = urlString else {
      showError(with: "Error selecting image")
      return
    }
    
    imageDidSelected?(urlString)
    dismiss(animated: true)
  }

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

// MARK: - Private

private extension ProfileImagesViewController {
  func configureCollectionView() {
    configureFlowLayout()
    collection.delegate = model?.collectionViewDelegate
    collection.dataSource = model?.collectionViewDataSource
    collection.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
  }

  func configureFlowLayout() {
    let cellPadding: CGFloat = 2
    collectionViewFlowLayout.scrollDirection = .vertical
    collectionViewFlowLayout.minimumLineSpacing = cellPadding
    collectionViewFlowLayout.minimumInteritemSpacing = cellPadding
    collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
    let itemsPerRow: CGFloat = 3
    let itemWidth = (view.frame.width - 4 * cellPadding) / itemsPerRow
    let itemSize = CGSize(width: itemWidth, height: itemWidth)
    collectionViewFlowLayout.itemSize = itemSize
  }
}

// MARK: - Instantiation from storybord

extension ProfileImagesViewController {
  static func storyboardInstance() -> ProfileImagesViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? ProfileImagesViewController
  }
}
