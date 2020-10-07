//
//  ThemeManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

typealias ThemeSettings = ThemeManager.ThemeSettings

final class ThemeManager {
    
    struct ThemeSettings {
        static let defaultIncomingColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        static let defaultOutgoingColor = #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)
        static let defaultChatBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let defaultLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let defaultLabelText = "Classic"
        
        var theme: Theme = .classic
        var incomingColor: UIColor = defaultIncomingColor
        var outgoingColor: UIColor = defaultOutgoingColor
        var chatBackgroundColor: UIColor = defaultChatBackgroundColor
        var labelColor: UIColor = defaultLabelColor
        var labelText: String = defaultLabelText
        
        init() { }
    }
    
    enum Theme: Int {
        case classic, day, night
    }
    
    private enum Keys {
        static let incomingColor = "incomingColor"
        static let outgoingColor = "outgoingColor"
        static let chatBackgroundColor = "chatBackgroundColor"
        static let labelColor = "labelColor"
        static let labelText = "labelText"
        static let theme = "theme"
    }
    
    static let shared = ThemeManager()
    
    lazy var onThemeSelectedListener: (_ settings: ThemeSettings) -> Void = { [weak self] settings in
        self?.applyTheme(with: settings)
    }
    
    var themeSettings: ThemeSettings {
        get {
            return loadFromUserDefaults()
        }
        set {
            saveToUserDefaults(themeSettings: newValue)
        }
    }
    
    private init() { }
}

extension ThemeManager: ThemesPickerDelegate {
    func themeDidSelect(with settings: ThemeSettings) {
        applyTheme(with: settings)
    }
}

// MARK: - Private

private extension ThemeManager {
    func applyTheme(with settings: ThemeSettings) {
        self.themeSettings = settings
    }
    
    func loadFromUserDefaults() -> ThemeSettings {
        var themeSettings = ThemeSettings()
        
        if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.incomingColor) as? Dictionary<String, CGFloat>,
           let color = UIColor().fromDictionary(dictionary: storedColor) {
            themeSettings.incomingColor = color
        }
        
        if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.outgoingColor) as? Dictionary<String, CGFloat>,
           let color = UIColor().fromDictionary(dictionary: storedColor) {
            themeSettings.outgoingColor = color
        }
        
        if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.chatBackgroundColor) as? Dictionary<String, CGFloat>,
           let color = UIColor().fromDictionary(dictionary: storedColor) {
            themeSettings.chatBackgroundColor = color
        }
        
        if let storedColor = UserDefaults.standard.dictionary(forKey: Keys.labelColor) as? Dictionary<String, CGFloat>,
           let color = UIColor().fromDictionary(dictionary: storedColor) {
            themeSettings.labelColor = color
        }
        
        if let storedLabelText = UserDefaults.standard.string(forKey: Keys.labelText) {
            themeSettings.labelText = storedLabelText
        }
        
        if let storedTheme = Theme(rawValue:UserDefaults.standard.integer(forKey: Keys.theme)) {
            themeSettings.theme =  storedTheme
        }
        
        return themeSettings
    }
    
    func saveToUserDefaults(themeSettings newValue: ThemeSettings) {
        UserDefaults.standard.setValue(newValue.incomingColor.toDictionary(), forKey: Keys.incomingColor)
        UserDefaults.standard.setValue(newValue.outgoingColor.toDictionary(), forKey: Keys.outgoingColor)
        UserDefaults.standard.setValue(newValue.chatBackgroundColor.toDictionary(), forKey: Keys.chatBackgroundColor)
        UserDefaults.standard.setValue(newValue.labelColor.toDictionary(), forKey: Keys.labelColor)
        UserDefaults.standard.setValue(newValue.labelText, forKey: Keys.labelText)
        UserDefaults.standard.setValue(newValue.theme.rawValue, forKey: Keys.theme)
    }
}
