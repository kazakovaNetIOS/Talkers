//
//  ConversationsListTableViewDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListTableViewDelegate: NSObject {
  private let model: ConversationsListModelProtocol

  init(model: ConversationsListModelProtocol) {
    self.model = model
  }
}

// MARK: - UITableViewDelegate

extension ConversationsListTableViewDelegate: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    model.selectChannel(at: indexPath)
  }
}
