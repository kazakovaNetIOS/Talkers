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
  // Создает экран упрвления темами
  func themesViewController() -> ThemesViewController
  // Создает экран профиля
  func profileViewController() -> UINavigationController
  // Создает экран выбора изображения профиля
  func profileImagesViewController(imageDidSelected: @escaping (String) -> Void) -> ProfileImagesViewController
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
    var model = conversationModel(with: channel)

    guard let conversationVC = ConversationViewController.storyboardInstance() else {
      fatalError("Can't initialize ConversationViewController from storyboard")
    }

    model.delegate = conversationVC
    model.setFRCDelegate(delegate: conversationVC)
    conversationVC.model = model

    return conversationVC
  }

  // MARK: - ThemesViewController
  func themesViewController() -> ThemesViewController {
    let model = themesModel()

    guard let themesVC = ThemesViewController.storyboardInstance() else {
      fatalError("Can't initialize ThemesViewController from storyboard")
    }
    
    themesVC.model = model

    return themesVC
  }

  // MARK: - ProfileViewController
  func profileViewController() -> UINavigationController {
    var model = profileModel()

    guard let navVC = ProfileViewController.storyboardInstance() else {
      fatalError("Can't initialize ProfileViewController from storyboard")
    }

    guard let profileVC = navVC.topViewController as? ProfileViewController else {
      fatalError("Can't initialize ProfileViewController from storyboard")
    }
    profileVC.presentationAssembly = self

    model.delegate = profileVC
    profileVC.model = model
    profileVC.buttonAnimator = TremblingButtonAnimator()

    return navVC
  }

  // MARK: - ProfileImagesViewController
  func profileImagesViewController(imageDidSelected: @escaping (String) -> Void) -> ProfileImagesViewController {
    var model = profileImagesModel()

    guard let profileImagesVC = ProfileImagesViewController.storyboardInstance() else {
      fatalError("Can't initialize ProfileImagesViewController from storyboard")
    }

    model.delegate = profileImagesVC
    profileImagesVC.model = model
    profileImagesVC.imageDidSelected = imageDidSelected

    return profileImagesVC
  }
}

// MARK: - Private

private extension PresentationAssembly {
  func channelsModel() -> ConversationsListModelProtocol {
    return ConversationsListModel(channelsService: serviceAssembly.channelsService,
                                  themesService: serviceAssembly.themesService)
  }

  func conversationModel(with channel: ChannelMO) -> ConversationModelProtocol {
    return ConversationModel(messagesService: serviceAssembly.messagesService,
                             profileService: serviceAssembly.profileService,
                             themesService: serviceAssembly.themesService,
                             channel: channel)
  }

  func themesModel() -> ThemesModelProtocol {
    return ThemesModel(themesService: serviceAssembly.themesService)
  }

  func profileModel() -> ProfileModelProtocol {
    return ProfileModel(profileService: serviceAssembly.profileService,
                        themesService: serviceAssembly.themesService,
                        profileImagesService: serviceAssembly.profileImagesService)
  }

  func profileImagesModel() -> ProfileImagesModelProtocol {
    return ProfileImagesModel(profileImagesService: serviceAssembly.profileImagesService, themesService: serviceAssembly.themesService)
  }
}
