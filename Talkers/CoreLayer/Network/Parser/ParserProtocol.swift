//
//  ParserProtocol.swift
//  Talkers
//
//  Created by Natalia Kazakova on 24.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ParserProtocol {
  associatedtype Model
  func parse(jsonData: Data) -> Model?
}
