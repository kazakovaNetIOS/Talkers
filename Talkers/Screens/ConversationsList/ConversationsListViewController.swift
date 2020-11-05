//
//  ConversationsListViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: BaseViewController {
  private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

  private var dataManager = ConversationsListDataManager()
  private lazy var coreDataStack = CoreDataStack(modelName: "Chats")

  private lazy var fetchedResultsController: NSFetchedResultsController<ChannelMO> = {
    let fetchRequest: NSFetchRequest<ChannelMO> = ChannelMO.fetchRequest()

    let sortDescriptor = NSSortDescriptor(key: #keyPath(ChannelMO.lastActivity), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: self.coreDataStack.managedContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: "talkersChannels")
    fetchResultsController.delegate = self

    return fetchResultsController
  }()

  @IBOutlet weak var conversationsListTableView: UITableView!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureTableView()

    do {
      try fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("\(fetchError), \(fetchError.localizedDescription)")
    }

    dataManager.startLoading()
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
    guard let sections = fetchedResultsController.sections else { return 0 }

    let sectionsInfo = sections[section]
    return sectionsInfo.numberOfObjects
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let channelMO = fetchedResultsController.object(at: indexPath)

    guard let cell = tableView.dequeueReusableCell(
    withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else {
      return UITableViewCell()
    }

    cell.configure(with: Channel(channelMO))

    return cell
  }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let conversationViewController = ConversationViewController.storyboardInstance() {
      let channelMO = fetchedResultsController.object(at: indexPath)
      conversationViewController.channel = Channel(channelMO)

      navigationController?.pushViewController(conversationViewController, animated: true)
    }
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let deletedChannel = fetchedResultsController.object(at: indexPath)
      coreDataStack.managedContext.delete(deletedChannel)
      coreDataStack.saveContext()
    }
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
      let channelMO = fetchedResultsController.object(at: indexPath)
      cell.configure(with: Channel(channelMO))
      print("Обновлен канал")
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
    conversationsListTableView.endUpdates()
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

// MARK: - Instantiation from storybord

extension ConversationsListViewController {
  static func storyboardInstance() -> ConversationsListViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? ConversationsListViewController
  }
}
