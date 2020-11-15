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
  @IBOutlet weak var nameLabel: UILabel!
}

// MARK: - ConfigurableView

extension ConversationTableViewCell: ConfigurableView {
  typealias ConfigurationModel = Message

  func configure(with model: ConfigurationModel, themeSettings: ThemeSettings) {
    messageLabel.text = model.content
    messageLabel.textColor = themeSettings.labelColor

    if !model.isMyMessage {
      nameLabel.text = model.senderName
    }

    containerView.layer.cornerRadius = 8.0
    containerView.clipsToBounds = true

    containerView.backgroundColor = model.isMyMessage ?
      themeSettings.outgoingColor : themeSettings.incomingColor

    contentView.backgroundColor = themeSettings.chatBackgroundColor
  }
}
