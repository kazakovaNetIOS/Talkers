//
//  ThemeSettings.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

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
