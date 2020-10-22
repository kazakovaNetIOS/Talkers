//
//  String+Extensions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 22.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

extension String {
  var isEmptyOrConsistWhitespaces: Bool {
    self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
