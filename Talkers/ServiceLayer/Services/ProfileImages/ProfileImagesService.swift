//
//  ProfileImagesService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ProfileImagesServiceProtocol {
  var delegate: ProfileImagesServiceDelegateProtocol? { get set }
  func getAvatarList()
}

protocol ProfileImagesServiceDelegateProtocol: class {
  func downloadImagesDidFinish(images: PixabayImages)
  func processError(with message: String)
}

class ProfileImagesService {
  private let key = "9665918-5c24fd510db60ddcbef834d2e"
  // https://pixabay.com/api/?key=9665918-5c24fd510db60ddcbef834d2e&q=cat&image_type=photo&pretty=true&safesearch=true&order=popular&per_page=200
  weak var delegate: ProfileImagesServiceDelegateProtocol?
  private let session = URLSession.shared
  private var url: URL? {
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
}

// MARK: - ProfileImagesServiceProtocol

extension ProfileImagesService: ProfileImagesServiceProtocol {
  func getAvatarList() {
    guard let url = url else { return }

    let task = session.dataTask(with: url) {[weak self] data, response, error in
      if error != nil || data == nil {
        self?.delegate?.processError(with: "Client error!")
        return
      }

      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        self?.delegate?.processError(with: "Server error!")
        return
      }

      guard let mime = response.mimeType, mime == "application/json" else {
        self?.delegate?.processError(with: "Wrong MIME type!")
        return
      }

      if let jsonData = data {
        do {
          let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
          // todo
          print(json)

          let decoder = JSONDecoder()
          let pixabayImages = try decoder.decode(PixabayImages.self, from: jsonData)

          DispatchQueue.main.async {
            self?.delegate?.downloadImagesDidFinish(images: pixabayImages)
          }

        } catch {
          self?.delegate?.processError(with: "JSON error: \(error.localizedDescription)")
        }
      }
    }

    task.resume()
  }
}
