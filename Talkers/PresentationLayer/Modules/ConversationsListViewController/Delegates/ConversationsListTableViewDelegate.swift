//
//  ConversationsListTableViewDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListTableViewDelegate: NSObject {
  private let model: ChannelsModel
  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

  init(model: ChannelsModel) {
    self.model = model
  }
}

// MARK: - UITableViewDelegate

extension ConversationsListTableViewDelegate: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    model.selectChannel(at: indexPath)
  }

  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete { model.deleteChannel(at: indexPath) }
  }
}
