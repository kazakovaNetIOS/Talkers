//
//  UIBarButtonItem.swift
//  Talkers
//
//  Created by Natalia Kazakova on 29.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  var view: UIView? {
    guard let view = self.value(forKey: "view") as? UIView else { return nil }
    return view
  }
}
