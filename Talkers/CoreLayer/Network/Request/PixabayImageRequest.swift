//
//  PixabayImageRequest.swift
//  Talkers
//
//  Created by Natalia Kazakova on 25.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class PixabayImageRequest {
  private let baseUrl: String =  "https://pixabay.com"
  private let apiVersion: String = "/api"
  private var apiKey: String
  private var getParameters: [String: String] {
    return ["key": apiKey,
            "q": "cat",
            "image_type": "photo",
            "pretty": "true",
            "safesearch": "true",
            "order": "popular",
            "per_page": "200"]
  }
  private var urlString: String {
    let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
    return baseUrl + apiVersion + "?" + getParams
  }

  init(apiKey: String) {
    self.apiKey = apiKey
  }
}

// MARK: - RequestProtocol

extension PixabayImageRequest: RequestProtocol {
  var urlRequest: URLRequest? {
    if let url = URL(string: urlString) {
      return URLRequest(url: url)
    }
    return nil
  }
}
