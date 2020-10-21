//
//  ConversationTableViewCell.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
  enum MessageType {
    case incoming, outgoing
  }

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
}

// MARK: - ConfigurableView

extension ConversationTableViewCell: ConfigurableView {
  typealias ConfigurationModel = Message

  func configure(with model: ConfigurationModel) {
    messageLabel.text = model.content
    messageLabel.textColor = ThemeManager.shared.themeSettings.labelColor

    containerView.layer.cornerRadius = 8.0
    containerView.clipsToBounds = true

//    switch model.type {
//    case .incoming:
      containerView.backgroundColor = ThemeManager.shared.themeSettings.incomingColor
//    case .outgoing:
//      containerView.backgroundColor = ThemeManager.shared.themeSettings.outgoingColor
//    }

    contentView.backgroundColor = ThemeManager.shared.themeSettings.chatBackgroundColor
  }
}
