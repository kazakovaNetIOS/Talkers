//
//  ConversationViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
  var channel: Channel?

  private let incomingMessageCellIdentifier = "IncomingConversationTableViewCell"
  private let outgoingMessageCellIdentifier = "OutgoingConversationTableViewCell"
  
  private var dataManager = ConversationsDataManager()

  private lazy var fetchedResultsController: NSFetchedResultsController<MessageMO> = {
    guard let channel = channel,
          let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError()
    }

    let fetchRequest: NSFetchRequest<MessageMO> = MessageMO.fetchRequest()

    let predicate = NSPredicate(format: "\(#keyPath(MessageMO.channelId)) == %@", channel.identifier)
    fetchRequest.predicate = predicate

    let sortDescriptor = NSSortDescriptor(key: #keyPath(MessageMO.created), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: appDelegate.coreDataStack.mainContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: "talkersMessages")
    fetchResultsController.delegate = self

    return fetchResultsController
  }()

  @IBOutlet weak var conversationTableView: UITableView!
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var rootViewBottomConstraint: NSLayoutConstraint!

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let channel = channel else { return }
    self.navigationItem.title = channel.name

    configureTableView()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )

    do {
      try fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("\(fetchError), \(fetchError.localizedDescription)")
    }

    dataManager.startLoading(channelId: channel.identifier) { [weak self] in
      self?.conversationTableView?.reloadData()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    changeColorsForTheme(with: ThemeManager.shared.themeSettings)
    conversationTableView.reloadData()
  }

  // MARK: - IBAction

  @IBAction func messageSendButtonTapped(_ sender: Any) {
    guard let channel = self.channel,
          let messageText = messageTextField.text else {
      messageTextField.text = ""
      return
    }

    let message = Message(
      channelId: channel.identifier,
      content: messageText,
      created: Date(),
      senderId: ConversationsDataManager.mySenderId,
      // TODO захардкожено имя, так как не реализована возможность вытащить его быстро из профиля
      senderName: "Natalia Kazakova")

    dataManager.addMessage(with: message)

    messageTextField.text = ""
  }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else { return 0 }

    let sectionsInfo = sections[section]
    return sectionsInfo.numberOfObjects
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let messageMO = fetchedResultsController.object(at: indexPath)
    let message = Message(messageMO)

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

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    conversationTableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      guard let newIndexPath = newIndexPath else { return }
      conversationTableView.insertRows(at: [newIndexPath], with: .automatic)
      print("Добавлено новое сообщение")
    case .delete:
      guard let indexPath = indexPath else { return }
      conversationTableView.deleteRows(at: [indexPath], with: .automatic)
      print("Удалено сообщение")
    case .update:
      guard let indexPath = indexPath,
            let cell = conversationTableView.cellForRow(at: indexPath) as? ConversationTableViewCell else { return }
      let messageMO = fetchedResultsController.object(at: indexPath)
      cell.configure(with: Message(messageMO))
      print("Обновлено сообщение")
    case .move:
      guard let indexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
      conversationTableView.deleteRows(at: [indexPath], with: .automatic)
      conversationTableView.insertRows(at: [newIndexPath], with: .automatic)
      print("Перемещено сообщение")
    @unknown default:
      print("Unexpected NSFetchedResultsChangeType")
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    conversationTableView.endUpdates()
  }
}

// MARK: - Private

private extension ConversationViewController {
  func configureTableView() {
    conversationTableView.dataSource = self
    conversationTableView.register(
      UINib(nibName: incomingMessageCellIdentifier, bundle: nil),
      forCellReuseIdentifier: incomingMessageCellIdentifier)

    conversationTableView.register(
      UINib(nibName: outgoingMessageCellIdentifier, bundle: nil),
      forCellReuseIdentifier: outgoingMessageCellIdentifier)
    conversationTableView.separatorStyle = .none
  }

  func changeColorsForTheme(with settings: ThemeSettings) {
    setNavigationBarForTheme()

    conversationTableView.backgroundColor = settings.chatBackgroundColor
  }

  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
       keyboardSize.height > 0 {

      rootViewBottomConstraint.constant = keyboardSize.height + view.safeAreaInsets.bottom

      UIView.animate(withDuration: 1.0) {
        self.view.layoutIfNeeded()
      }
    }
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    rootViewBottomConstraint.constant = 0

    UIView.animate(withDuration: 1.0) {
      self.view.layoutIfNeeded()
    }
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
