//
//  ConversationsListViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: BaseViewController {
  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
  private var dataManager = ConversationsListDataManager()

  @IBOutlet weak var conversationsListTableView: UITableView!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureTableView()

    dataManager.startLoading { [weak self] in
      self?.conversationsListTableView.reloadData()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // needed to clear the text in the back navigation
    self.navigationItem.title = " "
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    changeColorsForTheme(with: ThemeManager.shared.themeSettings)
    conversationsListTableView.reloadData()

    self.navigationItem.title = "Channels"
  }

  // MARK: - IBAction

  @IBAction func profileIconTapped(_ sender: Any) {
    if let profileViewController = ProfileViewController.storyboardInstance() {
      present(profileViewController, animated: true)
    }
  }

  @IBAction func settingsIconTapped(_ sender: Any) {
    if let themesViewController = ThemesViewController.storyboardInstance(
      delegate: ThemeManager.shared, onThemeSelectedListener: ThemeManager.shared.onThemeSelectedListener) {
      navigationController?.pushViewController(themesViewController, animated: true)
    }
  }
  
  @IBAction func addChannelIconTapped(_ sender: Any) {
    let settings = BaseViewController.AlertMessageSettingsWithTextField(
      title: "Новый канал",
      message: nil,
      defaultActionTitle: "Создать",
      defaultActionHandler: { [weak self] alert in
        guard let channelName = alert.textFields?.first?.text else { return }
        self?.createNewChannel(withName: channelName)
      },
      cancelActionTitle: "Отмена",
      canceltActionHandler: { alert in
        alert.dismiss(animated: true)
      },
      textFieldPlaceholder: "Имя канала")

    showAlertWithTextField(with: settings)
  }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataManager.getConversationsCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let channel = dataManager.getConversation(by: indexPath)

    guard let cell = tableView.dequeueReusableCell(
    withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else {
      return UITableViewCell()
    }

    cell.configure(with: channel)

    return cell
  }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let conversationViewController = ConversationViewController.storyboardInstance() {
      conversationViewController.channel = dataManager.getConversation(by: indexPath)

      navigationController?.pushViewController(conversationViewController, animated: true)
    }
  }
}

// MARK: - Instantiation from storybord

extension ConversationsListViewController {
  static func storyboardInstance() -> ConversationsListViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? ConversationsListViewController
  }
}

// MARK: - Private

private extension ConversationsListViewController {
  func createNewChannel(withName channelName: String) {
    dataManager.addChannel(withName: channelName)
  }

  func configureTableView() {
    conversationsListTableView.delegate = self
    conversationsListTableView.dataSource = self
    conversationsListTableView.tableFooterView =
      UIView(frame: CGRect(x: 0, y: 0, width: conversationsListTableView.frame.size.width, height: 1))
    conversationsListTableView.register(
      UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
  }

  func changeColorsForTheme(with settings: ThemeSettings) {
    setNavigationBarForTheme()

    conversationsListTableView.backgroundColor = settings.chatBackgroundColor
  }
}
