//
//  PixabayParser.swift
//  Talkers
//
//  Created by Natalia Kazakova on 24.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class PixabayParser {

}

// MARK: - ParserProtocol

extension PixabayParser: ParserProtocol {
  typealias Model = PixabayImages

  func parse(jsonData: Data) -> PixabayImages? {
    do {
      guard (try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject]) != nil else {
        return nil
      }

      let decoder = JSONDecoder()
      let model = try decoder.decode(Model.self, from: jsonData)

      return model

    } catch {
      print("error trying to convert data to JSON")
      return nil
    }
  }
}
