//
//  RequestSender.swift
//  Talkers
//
//  Created by Natalia Kazakova on 24.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

enum RequestSenderError: Error {
  case errorResponce(String)
}

struct RequestConfig<Parser> where Parser: ParserProtocol {
  let request: RequestProtocol
  let parser: Parser
}

protocol RequestSenderProtocol {
  func send<Parser>(requestConfig: RequestConfig<Parser>,
                    completionHandler: @escaping(Result<Parser.Model, RequestSenderError>) -> Void)
}

class RequestSender {
  let session = URLSession.shared
}

// MARK: - RequestSenderProtocol

extension RequestSender: RequestSenderProtocol {
  func send<Parser>(requestConfig config: RequestConfig<Parser>,
                    completionHandler: @escaping (Result<Parser.Model, RequestSenderError>) -> Void) {
    guard let urlRequest = config.request.urlRequest else {
      completionHandler(.failure(.errorResponce("invalid Url")))
      return
    }

    let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error: Error?) in
      if let error = error {
        completionHandler(.failure(.errorResponce(error.localizedDescription)))
        return
      }
      guard let data = data,
            let parsedModel: Parser.Model = config.parser.parse(jsonData: data) else {
        completionHandler(.failure(.errorResponce("received data can't be parsed")))
        return
      }

      completionHandler(.success(parsedModel))
    }

    task.resume()
  }
}
