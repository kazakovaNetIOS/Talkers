//
//  ConversationsListTableViewCell.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell {

  var model: Channel?

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var lastMessageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
}

// MARK: - ConfigurableView

extension ConversationsListTableViewCell: ConfigurableView {
  typealias ConfigurationModel = Channel

  func configure(with model: ConfigurationModel) {
    changeColorsForTheme(with: ThemeManager.shared.themeSettings)

    setName(with: model.name)
    setMessage(with: model)
    setDate(with: model)
  }
}

// MARK: - Private

extension ConversationsListTableViewCell {
  private func setName(with name: String) {
    nameLabel?.text = name
  }

  private func setMessage(with model: ConfigurationModel) {
    if model.isEmptyMessage {
      setEmptyMessage()
    } else {
      lastMessageLabel?.text = model.lastMessage
    }
  }

  private func setEmptyMessage() {
    lastMessageLabel?.text = "No message yet"
    lastMessageLabel?.font = UIFont.italicSystemFont(ofSize: 13.0)
  }

  private func setDate(with model: ConfigurationModel) {
    guard let lastActivity = model.lastActivity else {
      dateLabel?.text = ""
      return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    let dateTemplate = isConversationDateInPast(lastActivity) ? "dd MMM" : "HH:mm"
    dateFormatter.setLocalizedDateFormatFromTemplate(dateTemplate)
    dateLabel?.text = dateFormatter.string(from: lastActivity)
  }

  private func isConversationDateInPast(_ date: Date) -> Bool {
    var calender = Calendar.current
    calender.timeZone = TimeZone.current
    let result = calender.compare(date, to: Date(), toGranularity: .day)
    return result == .orderedAscending
  }

  func changeColorsForTheme(with settings: ThemeSettings) {
    contentView.backgroundColor = settings.chatBackgroundColor
    lastMessageLabel?.textColor = settings.labelColor
    nameLabel?.textColor = settings.labelColor
    dateLabel?.textColor = settings.labelColor
  }
}
