//
//  ThemeManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ThemesServiceProtocol {
  var currentThemeSettings: ThemeSettings { get }
  func applyTheme(with settings: ThemeSettings)
}

final class ThemesService {
  lazy var onThemeSelectedListener: (_ settings: ThemeSettings) -> Void = { [weak self] settings in
    self?.applyTheme(with: settings)
  }

  var currentThemeSettings: ThemeSettings {
    get {
      return loadFromUserDefaults()
    }
    set {
      saveToUserDefaults(themeSettings: newValue)
    }
  }
}

extension ThemesService: ThemesServiceProtocol {
  func applyTheme(with settings: ThemeSettings) {
    self.currentThemeSettings = settings
  }
}

// MARK: - Private

private extension ThemesService {
  private enum Keys {
    static let incomingColor = "incomingColor"
    static let outgoingColor = "outgoingColor"
    static let chatBackgroundColor = "chatBackgroundColor"
    static let labelColor = "labelColor"
    static let labelText = "labelText"
    static let theme = "theme"
  }
  
  func loadFromUserDefaults() -> ThemeSettings {
    var themeSettings = ThemeSettings()

    if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.incomingColor) as? [String: CGFloat],
    let color = UIColor().fromDictionary(dictionary: storedColor) {
      themeSettings.incomingColor = color
    }

    if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.outgoingColor) as? [String: CGFloat],
    let color = UIColor().fromDictionary(dictionary: storedColor) {
      themeSettings.outgoingColor = color
    }

    if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.chatBackgroundColor) as? [String: CGFloat],
    let color = UIColor().fromDictionary(dictionary: storedColor) {
      themeSettings.chatBackgroundColor = color
    }

    if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.labelColor) as? [String: CGFloat],
    let color = UIColor().fromDictionary(dictionary: storedColor) {
      themeSettings.labelColor = color
    }

    if let storedLabelText = UserDefaults.standard.string(forKey: Keys.labelText) {
      themeSettings.labelText = storedLabelText
    }

    if let storedTheme = Theme(rawValue: UserDefaults.standard.integer(forKey: Keys.theme)) {
      themeSettings.theme = storedTheme
    }

    return themeSettings
  }

  func saveToUserDefaults(themeSettings newValue: ThemeSettings) {
    DispatchQueue.global(qos: .userInitiated).async {
      UserDefaults.standard.setValue(newValue.incomingColor.toDictionary(), forKey: Keys.incomingColor)
      UserDefaults.standard.setValue(newValue.outgoingColor.toDictionary(), forKey: Keys.outgoingColor)
      UserDefaults.standard.setValue(newValue.chatBackgroundColor.toDictionary(), forKey: Keys.chatBackgroundColor)
      UserDefaults.standard.setValue(newValue.labelColor.toDictionary(), forKey: Keys.labelColor)
      UserDefaults.standard.setValue(newValue.labelText, forKey: Keys.labelText)
      UserDefaults.standard.setValue(newValue.theme.rawValue, forKey: Keys.theme)
    }
  }
}
