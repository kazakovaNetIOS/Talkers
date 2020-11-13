//
//  ConversationsListDataSourceDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListTableViewDataSource: NSObject {
  private let model: ConversationsListModel
  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

  init(model: ConversationsListModel) {
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

    cell.configure(with: Channel(channelMO))

    return cell
  }
}
