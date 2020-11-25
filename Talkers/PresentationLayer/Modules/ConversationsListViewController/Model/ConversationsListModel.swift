//
//  ConversationsListModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationsListModelProtocol {
  var delegate: ConversationsListModelDelegateProtocol? { get set }
  var tableViewDataSource: ConversationsListTableViewDataSource { get }
  var tableViewDelegate: ConversationsListTableViewDelegate { get }
  var currentThemeSettings: ThemeSettings { get }

  func addChannel(withName channelName: String)
  func deleteChannel(at indexPath: IndexPath)
  func fetchChannels()
  func getChannel(at indexPath: IndexPath) -> ChannelMO
  func getNumbersOfObjects(for section: Int) -> Int
  func setFRCDelegate(delegate: NSFetchedResultsControllerDelegate)

  func selectChannel(at indexPath: IndexPath)
}

protocol ConversationsListModelDelegateProtocol: class {
  func didChannelSelected(with channel: ChannelMO)
  func show(error message: String)
}

class ConversationsListModel {
  weak var delegate: ConversationsListModelDelegateProtocol?
  private var channelsService: ChannelsServiceProtocol
  private var themesService: ThemesServiceProtocol

  lazy var fetchedResultsController: NSFetchedResultsController<ChannelMO> = {
    return channelsService.fetchedResultsController
  }()
  lazy var tableViewDataSource: ConversationsListTableViewDataSource = {
    return ConversationsListTableViewDataSource(model: self)
  }()
  lazy var tableViewDelegate: ConversationsListTableViewDelegate = {
    return ConversationsListTableViewDelegate(model: self)
  }()
  var currentThemeSettings: ThemeSettings {
    return themesService.currentThemeSettings
  }

  init(channelsService: ChannelsServiceProtocol,
       themesService: ThemesServiceProtocol) {
    self.channelsService = channelsService
    self.themesService = themesService
    self.channelsService.delegate = self
  }
}

// MARK: - ChannelsModelProtocol

extension ConversationsListModel: ConversationsListModelProtocol {
  func fetchChannels() {
    self.channelsService.fetchChannels()
  }

  func addChannel(withName channelName: String) {
    channelsService.addChannel(withName: channelName)
  }

  func deleteChannel(at indexPath: IndexPath) {
    let deletedChannel = self.fetchedResultsController.object(at: indexPath)
    channelsService.deleteChannel(channel: deletedChannel)
  }

  func getChannel(at indexPath: IndexPath) -> ChannelMO {
    return fetchedResultsController.object(at: indexPath)
  }

  func selectChannel(at indexPath: IndexPath) {
    let channel = fetchedResultsController.object(at: indexPath)
    self.delegate?.didChannelSelected(with: channel)
  }

  func getNumbersOfObjects(for section: Int) -> Int {
    guard let sections = self.fetchedResultsController.sections else { return 0 }

    let sectionsInfo = sections[section]
    return sectionsInfo.numberOfObjects
  }

  func setFRCDelegate(delegate: NSFetchedResultsControllerDelegate) {
    fetchedResultsController.delegate = delegate
  }
}

// MARK: - ChannelsServiceDelegateProtocol

extension ConversationsListModel: ChannelsServiceDelegateProtocol {
  func processError(with message: String) {
    delegate?.show(error: message)
  }
}
