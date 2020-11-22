//
//  JsonDecoder.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol JsonDecoderProtocol {
  func decode<Object: Decodable>(_ jsonData: Data) throws -> Object?
}

class JsonDecoder {

}

// MARK: - JsonDecoderProtocol

extension JsonDecoder: JsonDecoderProtocol {
  func decode<Object: Decodable>(_ jsonData: Data) throws -> Object? {
    let decoder = JSONDecoder()
    let object = try decoder.decode(Object.self, from: jsonData)

    return object
  }
}
