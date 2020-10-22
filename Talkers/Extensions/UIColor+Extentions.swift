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
    
    func toDictionary() -> Dictionary<String, Float> {
        switch self.rgba {
            case (let r, let g, let b, let a):
                return ["red": r, "green": g, "blue": b, "alpha": a]
        }
    }
    
    func fromDictionary(dictionary: Dictionary<String, CGFloat>?) -> UIColor? {
        guard let dictionary = dictionary,
              let r = dictionary["red"],
              let g = dictionary["green"],
              let b = dictionary["blue"],
              let a = dictionary["alpha"] else { return nil }
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
