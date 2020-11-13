//
//  ConversationViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: BaseViewController {
  var model: ConversationModelProtocol?

  private let incomingMessageCellIdentifier = "IncomingConversationTableViewCell"
  private let outgoingMessageCellIdentifier = "OutgoingConversationTableViewCell"

  @IBOutlet weak var conversationTableView: UITableView!
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var rootViewBottomConstraint: NSLayoutConstraint!

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    changeColorsForTheme(with: ThemeManager.shared.themeSettings)

    model?.fetchMessages()

    self.navigationItem.title = model?.channel.name
  }

  // MARK: - IBAction

  @IBAction func messageSendButtonTapped(_ sender: Any) {
    guard let messageText = messageTextField.text else {
      messageTextField.text = ""
      return
    }

    model?.addMessage(with: messageText)

    messageTextField.text = ""
  }
}

// MARK: - ConversationModelDelegateProtocol

extension ConversationViewController: ConversationModelDelegateProtocol {
  func show(error message: String) {
    let settings = BaseViewController.AlertMessageSettings(title: "Ошибка",
                                                           message: message,
                                                           defaultActionTitle: "Ok")
    showAlert(with: settings)
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
      if let message = model?.getMessage(at: indexPath) {
        cell.configure(with: message)
        print("Обновлено сообщение")
      }
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
    scrollToBottom()
  }
}

// MARK: - Private

private extension ConversationViewController {
  func configureTableView() {
    conversationTableView.dataSource = model?.tableViewDataSource
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

  private func scrollToBottom() {
    guard let count = model?.getMessagesCount(),
          count > 0 else { return }
    let row = count - 1
    let indexPath = IndexPath(row: row, section: 0)
    conversationTableView.scrollToRow(at: indexPath,
                          at: .bottom,
                          animated: true)
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
