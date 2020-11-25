//
//  ConversationTableViewDataSource.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationTableViewDataSource: NSObject {
  private let model: ConversationModel
  private let incomingMessageCellIdentifier = "IncomingConversationTableViewCell"
  private let outgoingMessageCellIdentifier = "OutgoingConversationTableViewCell"

  init(model: ConversationModel) {
    self.model = model
  }
}

// MARK: - UITableViewDataSource

extension ConversationTableViewDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.getNumbersOfObjects(for: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = model.getMessage(at: indexPath)

    var cell: ConversationTableViewCell?

    if message.isMyMessage {
      cell = tableView.dequeueReusableCell(
        withIdentifier: outgoingMessageCellIdentifier,
        for: indexPath) as? ConversationTableViewCell
    } else {
      cell = tableView.dequeueReusableCell(
        withIdentifier: incomingMessageCellIdentifier,
        for: indexPath) as? ConversationTableViewCell
    }

    guard let messageCell = cell else { return UITableViewCell() }

    messageCell.configure(with: message, themeSettings: model.currentThemeSettings)

    return messageCell
  }
}
