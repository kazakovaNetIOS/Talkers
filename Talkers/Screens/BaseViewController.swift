//
//  BaseViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  struct AlertMessageSettings {
    let title: String?
    let message: String?
    let defaultActionTitle: String?
    let defaultActionHandler: (() -> Void)?
    let cancelActionTitle: String?
    let canceltActionHandler: (() -> Void)?

    init (
      title: String?,
      message: String?,
      defaultActionTitle: String?,
      defaultActionHandler: (() -> Void)? = nil,
      cancelActionTitle: String? = nil,
      canceltActionHandler: (() -> Void)? = nil) {
      self.title = title
      self.message = message
      self.defaultActionTitle = defaultActionTitle
      self.defaultActionHandler = defaultActionHandler
      self.cancelActionTitle = cancelActionTitle
      self.canceltActionHandler = canceltActionHandler
    }
  }

  func showAlert(with settings: AlertMessageSettings) {
    let alert =
      UIAlertController(title: settings.title, message: settings.message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: settings.defaultActionTitle, style: .default) { _ in
      guard let handler = settings.defaultActionHandler else { return }
      handler()
    })

    if let cancelTitle = settings.cancelActionTitle {
      alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
        guard let handler = settings.canceltActionHandler else { return }
        handler()
      })
    }

    present(alert, animated: true)
  }
}
