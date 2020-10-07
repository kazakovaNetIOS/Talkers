//
//  Theme.swift
//  Talkers
//
//  Created by Natalia Kazakova on 07.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

enum Theme: Int {
    case classic, day, night
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .classic
    }
    
    var barStyle: UIBarStyle {
        switch self {
            case .classic, .day:
                return .default
            case .night:
                return .black
        }
    }
    
    var backgroundColor: UIColor {
        return ThemeManager.shared.themeSettings.chatBackgroundColor
    }
    
    var textColor: UIColor {
        return ThemeManager.shared.themeSettings.labelColor
    }
    
    func apply() {
//        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
//        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = ThemeManager.shared.themeSettings.labelColor
        UINavigationBar.appearance().barStyle = barStyle
        UITableViewCell.appearance().backgroundColor = backgroundColor
        UILabel.appearance().textColor = textColor
    }
}
