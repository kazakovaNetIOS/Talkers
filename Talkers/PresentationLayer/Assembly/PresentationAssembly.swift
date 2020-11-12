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

    return navVC
  }

  // MARK: - ConversationViewController
  func conversationViewController(with channel: ChannelMO) -> ConversationViewController {
//    var model = channelsModel()

    guard let conversationVC = ConversationViewController.storyboardInstance() else {
      fatalError("Can't initialize ConversationViewController from storyboard")
    }

//    model.delegate = conversationsListVC

    return conversationVC
  }
}

// MARK: - Private

private extension PresentationAssembly {
  func channelsModel() -> ChannelsModelProtocol {
    return ChannelsModel(channelsService: serviceAssembly.channelsService)
  }
}
