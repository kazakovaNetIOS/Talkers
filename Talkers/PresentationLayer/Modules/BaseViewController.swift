//
//  BaseViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  class AlertMessageSettings {
    let title: String?
    let message: String?
    let defaultActionTitle: String?
    let defaultActionHandler: ((UIAlertController) -> Void)?
    let cancelActionTitle: String?
    let canceltActionHandler: ((UIAlertController) -> Void)?

    init (
      title: String?,
      message: String?,
      defaultActionTitle: String?,
      defaultActionHandler: ((UIAlertController) -> Void)? = nil,
      cancelActionTitle: String? = nil,
      canceltActionHandler: ((UIAlertController) -> Void)? = nil) {
      self.title = title
      self.message = message
      self.defaultActionTitle = defaultActionTitle
      self.defaultActionHandler = defaultActionHandler
      self.cancelActionTitle = cancelActionTitle
      self.canceltActionHandler = canceltActionHandler
    }
  }

  class AlertMessageSettingsWithTextField: AlertMessageSettings {
    var textFieldPlaceholder: String?

    init (
      title: String?,
      message: String?,
      defaultActionTitle: String?,
      defaultActionHandler: ((UIAlertController) -> Void)? = nil,
      cancelActionTitle: String? = nil,
      canceltActionHandler: ((UIAlertController) -> Void)? = nil,
      textFieldPlaceholder: String? = nil) {
      super.init(
        title: title,
        message: message,
        defaultActionTitle: defaultActionTitle,
        defaultActionHandler: defaultActionHandler,
        cancelActionTitle: cancelActionTitle,
        canceltActionHandler: canceltActionHandler)

      self.textFieldPlaceholder = textFieldPlaceholder
    }
  }

  var notifObservers = [NSObjectProtocol]()

  deinit {
    for observer in notifObservers {
      NotificationCenter.default.removeObserver(observer)
    }
    notifObservers.removeAll()
  }

  func showAlert(with settings: AlertMessageSettings) {
    let alertController = getAlertController(with: settings)
    present(alertController, animated: true)
  }

  func showAlertWithTextField(with settings: AlertMessageSettingsWithTextField) {
    let alertController = getAlertController(with: settings)
    alertController.addTextField { textField in
      textField.placeholder = settings.textFieldPlaceholder

      let observer = NotificationCenter.default.addObserver(
        forName: UITextField.textDidChangeNotification,
        object: textField,
        queue: OperationQueue.main,
        using: {_ in
          let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
          let textIsNotEmpty = textCount > 0
          alertController.actions.first?.isEnabled = textIsNotEmpty
        })

      self.notifObservers.append(observer)
    }

    alertController.actions.first?.isEnabled = false

    present(alertController, animated: true)
  }

  func getAlertController(with settings: AlertMessageSettings) -> UIAlertController {
    let alert =
      UIAlertController(title: settings.title, message: settings.message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: settings.defaultActionTitle, style: .default) { _ in
      guard let handler = settings.defaultActionHandler else { return }
      handler(alert)
    })

    if let cancelTitle = settings.cancelActionTitle {
      alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
        guard let handler = settings.canceltActionHandler else { return }
        handler(alert)
      })
    }

    return alert
  }
}
