//
//  UIViewController+Extentions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

extension UIViewController {
  func setNavigationBarForTheme(themeSettings: ThemeSettings) {
    navigationController?.navigationBar.barStyle =
      themeSettings.theme == .night ? .black : .default
    navigationController?.navigationBar.tintColor =
      themeSettings.labelColor
    navigationController?.navigationBar.titleTextAttributes =
      [NSAttributedString.Key.foregroundColor: themeSettings.labelColor]
  }
}
