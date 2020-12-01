//
//  RequestsFactory.swift
//  Talkers
//
//  Created by Natalia Kazakova on 24.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

struct RequestsFactory {
  struct PixabayRequests {
    static func pixabayImagesConfig() -> RequestConfig<PixabayParser> {
      let request = PixabayImageRequest(apiKey: "9665918-5c24fd510db60ddcbef834d2e")
      return RequestConfig<PixabayParser>(request: request, parser: PixabayParser())
    }
  }
}
