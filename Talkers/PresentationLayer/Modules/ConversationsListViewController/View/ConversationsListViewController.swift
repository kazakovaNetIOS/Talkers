//
//  ConversationsListViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: BaseViewController {
  var presentationAssembly: PresentationAssemblyProtocol?
  var model: ConversationsListModelProtocol?

  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

  @IBOutlet weak var conversationsListTableView: UITableView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let themeSettings = model?.currentThemeSettings {
      changeColorsForTheme(with: themeSettings)
    }

    model?.fetchChannels()

    self.navigationItem.title = "Channels"
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // needed to clear the text in the back navigation
    self.navigationItem.title = " "
  }

  // MARK: - IBAction

  @IBAction func profileIconTapped(_ sender: Any) {
    if let profileViewController = presentationAssembly?.profileViewController() {
      present(profileViewController, animated: true)
    }
  }

  @IBAction func settingsIconTapped(_ sender: Any) {
    if let themesViewController = presentationAssembly?.themesViewController() {
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

// MARK: - ChannelsModelDelegateProtocol

extension ConversationsListViewController: ConversationsListModelDelegateProtocol {
  func show(error message: String) {
    let settings = BaseViewController.AlertMessageSettings(title: "Ошибка",
                                                           message: message,
                                                           defaultActionTitle: "Ok")
    showAlert(with: settings)
  }

  func didChannelSelected(with channel: ChannelMO) {
    if let conversationViewController = presentationAssembly?.conversationViewController(with: channel) {
      navigationController?.pushViewController(conversationViewController, animated: true)
    }
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    loadingIndicator.startAnimating()
    conversationsListTableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      guard let newIndexPath = newIndexPath else { return }
      conversationsListTableView.insertRows(at: [newIndexPath], with: .automatic)
      print("Добавлен новый канал")
    case .delete:
      guard let indexPath = indexPath else { return }
      conversationsListTableView.deleteRows(at: [indexPath], with: .automatic)
      print("Удален канал")
    case .update:
      guard let indexPath = indexPath,
            let cell = conversationsListTableView.cellForRow(at: indexPath) as? ConversationsListTableViewCell else { return }
      if let channelMO = model?.getChannel(at: indexPath),
         let themeSettings = model?.currentThemeSettings {
        cell.configure(with: Channel(channelMO), themeSettings: themeSettings)
        print("Обновлен канал")
      }
    case .move:
      guard let indexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
      conversationsListTableView.deleteRows(at: [indexPath], with: .automatic)
      conversationsListTableView.insertRows(at: [newIndexPath], with: .automatic)
      print("Перемещен канал")
    @unknown default:
      print("Unexpected NSFetchedResultsChangeType")
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    loadingIndicator.stopAnimating()
    conversationsListTableView.endUpdates()
  }
}

// MARK: - Private

private extension ConversationsListViewController {
  func createNewChannel(withName channelName: String) {
    model?.addChannel(withName: channelName)
  }

  func configureTableView() {
    conversationsListTableView.delegate = model?.tableViewDelegate
    conversationsListTableView.dataSource = model?.tableViewDataSource
    conversationsListTableView.tableFooterView =
      UIView(frame: CGRect(x: 0, y: 0, width: conversationsListTableView.frame.size.width, height: 1))
    conversationsListTableView.register(
      UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
  }

  func changeColorsForTheme(with settings: ThemeSettings) {
    setNavigationBarForTheme(themeSettings: settings)
    conversationsListTableView.backgroundColor = settings.chatBackgroundColor
  }
}

// MARK: - Instantiation from storybord

extension ConversationsListViewController {
  static func storyboardInstance() -> UINavigationController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? UINavigationController
  }
}
