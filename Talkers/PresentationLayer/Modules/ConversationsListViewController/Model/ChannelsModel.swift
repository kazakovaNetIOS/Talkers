//
//  ConversationsListModel.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelsModelProtocol {
  var delegate: ChannelsModelDelegateProtocol? { get set }
  var tableViewDataSource: ConversationsListTableViewDataSource { get }
  var tableViewDelegate: ConversationsListTableViewDelegate { get }

  func addChannel(withName channelName: String)
  func deleteChannel(at indexPath: IndexPath)
  func fetchChannels()
  func getChannel(at indexPath: IndexPath) -> ChannelMO
  func getNumbersOfObjects(for section: Int) -> Int
  func setFRCDelegate(delegate: NSFetchedResultsControllerDelegate)

  func selectChannel(at indexPath: IndexPath)
}

protocol ChannelsModelDelegateProtocol: class {
  func didChannelSelected(with channel: ChannelMO)
  func show(error message: String)
}

class ChannelsModel {
  weak var delegate: ChannelsModelDelegateProtocol?
  private var channelsService: ChannelsServiceProtocol

  lazy var fetchedResultsController: NSFetchedResultsController<ChannelMO> = {
    return channelsService.getFRC()
  }()
  lazy var tableViewDataSource: ConversationsListTableViewDataSource = {
    return ConversationsListTableViewDataSource(model: self)
  }()
  lazy var tableViewDelegate: ConversationsListTableViewDelegate = {
    return ConversationsListTableViewDelegate(model: self)
  }()

  init(channelsService: ChannelsServiceProtocol) {
    self.channelsService = channelsService
    self.channelsService.delegate = self
  }
}

// MARK: - ChannelsModelProtocol

extension ChannelsModel: ChannelsModelProtocol {
  func fetchChannels() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }

      do {
        try self.fetchedResultsController.performFetch()
      } catch {
        let fetchError = error as NSError
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.delegate?.show(error: "\(fetchError), \(fetchError.localizedDescription)")
        }
      }

      DispatchQueue.global(qos: .userInitiated).async {
        self.channelsService.fetchChannels()
      }
    }
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

extension ChannelsModel: ChannelsServiceDelegateProtocol {
  func processError(with message: String) {
    DispatchQueue.main.async { [weak self] in
      self?.delegate?.show(error: message)
    }
  }

  func didFinishDeleting() {
    // todo
  }
}
