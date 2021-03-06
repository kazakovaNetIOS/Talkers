//
//  ProfileImagesService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ProfileImagesServiceProtocol {
  var delegate: ProfileImagesServiceDelegateProtocol? { get set }
  func loadAvatarList()
  func loadImage(by urlString: String, completion: @escaping (Result<UIImage?, RequestSenderError>) -> Void)
}

protocol ProfileImagesServiceDelegateProtocol: class {
  func downloadAvatarListDidFinish(images: PixabayImages?)
  func processError(with message: String)
}

class ProfileImagesService {
  private let key = "9665918-5c24fd510db60ddcbef834d2e"
  weak var delegate: ProfileImagesServiceDelegateProtocol?
  private let session = URLSession.shared
  private var avatarListUrl: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "pixabay.com"
    components.path = "/api"
    components.queryItems = [
      URLQueryItem(name: "key", value: key),
      URLQueryItem(name: "q", value: "cat"),
      URLQueryItem(name: "image_type", value: "photo"),
      URLQueryItem(name: "pretty", value: "true"),
      URLQueryItem(name: "safesearch", value: "true"),
      URLQueryItem(name: "order", value: "popular"),
      URLQueryItem(name: "per_page", value: "200")
    ]

    return components.url
  }
  private var requestSender: RequestSenderProtocol

  init(requestSender: RequestSenderProtocol) {
    self.requestSender = requestSender
  }
}

// MARK: - ProfileImagesServiceProtocol

extension ProfileImagesService: ProfileImagesServiceProtocol {
  func loadAvatarList() {
    let requestConfig = RequestsFactory.PixabayRequests.pixabayImagesConfig()

    requestSender.send(requestConfig: requestConfig) { [weak self] result in
      switch result {
      case .success(let images):
        DispatchQueue.main.async {
          self?.delegate?.downloadAvatarListDidFinish(images: images)
        }
      case.failure(let error):
        self?.delegate?.processError(with: error.localizedDescription)
      }
    }
  }

  func loadImage(by urlString: String, completion: @escaping (Result<UIImage?, RequestSenderError>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(.errorResponce("invalid Url")))
      return
    }

    let task = session.dataTask(with: url) {[weak self] data, response, error in
      guard let isRequestSuccess = self?.processDataTaskResult(data, response, error),
            let data = data else {
        completion(.success(nil))
        return
      }

      if isRequestSuccess,
         let downloadedImage = UIImage(data: data) {
        DispatchQueue.main.async {
          completion(.success(downloadedImage))
        }
      }
    }

    task.resume()
  }
}

// MARK: - Private

private extension ProfileImagesService {
  func processDataTaskResult(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Bool {
    if error != nil || data == nil {
      self.delegate?.processError(with: "Client error!")
      return false
    }

    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
      self.delegate?.processError(with: "Server error!")
      return false
    }

    return true
  }
}
