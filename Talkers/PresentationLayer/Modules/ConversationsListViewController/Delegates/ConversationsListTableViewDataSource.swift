//
//  ConversationsListDataSourceDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListTableViewDataSource: NSObject {
  private let model: ConversationsListModelProtocol
  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

  init(model: ConversationsListModelProtocol) {
    self.model = model
  }
}

// MARK: - UITableViewDataSource

extension ConversationsListTableViewDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.getNumbersOfObjects(for: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let channelMO = self.model.getChannel(at: indexPath)

    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else {
      return UITableViewCell()
    }

    cell.configure(with: Channel(channelMO), themeSettings: model.currentThemeSettings)

    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete { model.deleteChannel(at: indexPath) }
  }
}
