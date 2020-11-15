//
//  ConfigurableView.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ConfigurableView {
  associatedtype ConfigurationModel

  func configure(with model: ConfigurationModel, themeSettings: ThemeSettings)
}
