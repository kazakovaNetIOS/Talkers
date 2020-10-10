//
//  UIViewController+Extentions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

extension UIViewController {
  func setNavigationBarForTheme() {
    navigationController?.navigationBar.barStyle =
      ThemeManager.shared.themeSettings.theme == .night ? .black : .default
    navigationController?.navigationBar.tintColor =
      ThemeManager.shared.themeSettings.labelColor
    navigationController?.navigationBar.titleTextAttributes =
      [NSAttributedString.Key.foregroundColor: ThemeManager.shared.themeSettings.labelColor]
  }
}
