//
//  PresentationAssembly.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProtocol {
  // Создает экран со списком чатов
  func conversationsListViewController() -> UINavigationController
  // Создает экран со списком сообщений
  func conversationViewController(with channel: ChannelMO) -> ConversationViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {
  private let serviceAssembly: ServiceAssemblyProtocol
  private var conversationsListVC: ConversationsListViewController?

  init(serviceAssembly: ServiceAssemblyProtocol) {
    self.serviceAssembly = serviceAssembly
  }

  // MARK: - ConversationsListViewController
  func conversationsListViewController() -> UINavigationController {
    var model = channelsModel()

    guard let navVC = ConversationsListViewController.storyboardInstance() else {
      fatalError("Can't initialize ConversationsListViewController from storyboard")
    }

    guard let conversationsListVC = navVC.topViewController as? ConversationsListViewController else {
      fatalError("Can't initialize ConversationsListViewController from storyboard")
    }
    conversationsListVC.presentationAssembly = self

    model.delegate = conversationsListVC
    model.setFRCDelegate(delegate: conversationsListVC)
    conversationsListVC.model = model

    self.conversationsListVC = conversationsListVC

    return navVC
  }

  // MARK: - ConversationViewController
  func conversationViewController(with channel: ChannelMO) -> ConversationViewController {
    var model = conversationModel(with: channel)

    guard let conversationVC = ConversationViewController.storyboardInstance() else {
      fatalError("Can't initialize ConversationViewController from storyboard")
    }

    model.delegate = conversationVC
    model.setFRCDelegate(delegate: conversationVC)
    conversationVC.model = model

    return conversationVC
  }
}

// MARK: - Private

private extension PresentationAssembly {
  func channelsModel() -> ConversationsListModelProtocol {
    return ConversationsListModel(channelsService: serviceAssembly.channelsService)
  }

  func conversationModel(with channel: ChannelMO) -> ConversationModelProtocol {
    return ConversationModel(messagesService: serviceAssembly.messagesService,
                             userProfileService: serviceAssembly.userProfileService,
                             channel: channel)
  }
}
