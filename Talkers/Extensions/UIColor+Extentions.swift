//
//  UIColor+Extentions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

extension UIColor {
  var rgba: (red: Float, green: Float, blue: Float, alpha: Float) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return (Float(red), Float(green), Float(blue), Float(alpha))
  }

  func toDictionary() -> [String: Float] {
    switch self.rgba {
    case let (red, green, blue, alpha):
      return ["red": red, "green": green, "blue": blue, "alpha": alpha]
    }
  }

  func fromDictionary(dictionary: [String: CGFloat]?) -> UIColor? {
    guard let dictionary = dictionary,
    let red = dictionary["red"],
    let green = dictionary["green"],
    let blue = dictionary["blue"],
    let alpha = dictionary["alpha"] else { return nil }

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}
