//
//  ConversationViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
  var channel: Channel? {
    didSet {
      guard let channel = channel else { return }

      dataManager = ConversationsDataManager(channelId: channel.identifier) { [weak self] in
        self?.conversationTableView.reloadData()
      }
    }
  }

  private let incomingMessageCellIdentifier = "IncomingConversationTableViewCell"
  private let outgoingMessageCellIdentifier = "OutgoingConversationTableViewCell"
  private var dataManager: ConversationsDataManager?

  @IBOutlet weak var conversationTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.title = channel?.name

    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    setNavigationBarForTheme()
    conversationTableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataManager?.getConversationsCount() ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let message = dataManager?.getConversation(by: indexPath) else {
      return UITableViewCell()
    }

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

    messageCell.configure(with: message)

    return messageCell
  }
}

// MARK: - Instantiation from storybord

extension ConversationViewController {
  static func storyboardInstance() -> ConversationViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
    return navigationController?.topViewController as? ConversationViewController
  }
}

// MARK: - Private

extension ConversationViewController {
  private func configureTableView() {
    conversationTableView.dataSource = self
    conversationTableView.register(
      UINib(nibName: incomingMessageCellIdentifier, bundle: nil),
      forCellReuseIdentifier: incomingMessageCellIdentifier)

    conversationTableView.register(
      UINib(nibName: outgoingMessageCellIdentifier, bundle: nil),
      forCellReuseIdentifier: outgoingMessageCellIdentifier)
    conversationTableView.separatorStyle = .none
  }
}
