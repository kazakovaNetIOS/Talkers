//
//  ConversationsListDataSourceDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListDataSource: NSObject {
  private let model: ChannelsModel
  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

  init(model: ChannelsModel) {
    self.model = model
  }
}

// MARK: - UITableViewDataSource

extension ConversationsListDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = self.model.fetchedResultsController.sections else { return 0 }

    let sectionsInfo = sections[section]
    return sectionsInfo.numberOfObjects
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let channelMO = self.model.fetchedResultsController.object(at: indexPath)

    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else {
      return UITableViewCell()
    }

    cell.configure(with: Channel(channelMO))

    return cell
  }
}
