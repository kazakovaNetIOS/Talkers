//
//  ThemesModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ThemesModelProtocol {
  var currentThemeSettings: ThemeSettings { get }
  func themeDidSelect(with settings: ThemeSettings)
}

class ThemesModel {
  private var themesService: ThemesServiceProtocol

  var currentThemeSettings: ThemeSettings {
    return themesService.currentThemeSettings
  }

  init(themesService: ThemesServiceProtocol) {
    self.themesService = themesService
  }
}

// MARK: - ThemesModelProtocol

extension ThemesModel: ThemesModelProtocol {
  func themeDidSelect(with settings: ThemeSettings) {
    themesService.applyTheme(with: settings)
  }
}
