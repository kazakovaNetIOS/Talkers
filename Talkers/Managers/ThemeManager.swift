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
        static let defaultChatBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.9294117647, alpha: 1)
        static let defaultLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let defaultLabelText = "Classic"
        
        var incomingColor: UIColor = defaultIncomingColor
        var outgoingColor: UIColor = defaultOutgoingColor
        var chatBackgroundColor: UIColor = defaultChatBackgroundColor
        var labelColor: UIColor = defaultLabelColor
        var labelText: String = defaultLabelText
        
        init() { }
    }
    
    static let shared = ThemeManager()
    
    let onThemeSelectedListener: (_ settings: ThemeSettings) -> Void = { settings in
        print("themeSelected from themeManager")
    }
    
    var themeSettings = ThemeSettings()
    
    private init() { }
}

extension ThemeManager: ThemesPickerDelegate {
    func themeSelected(with settings: ThemeSettings) {
        self.themeSettings = settings
    }
}
