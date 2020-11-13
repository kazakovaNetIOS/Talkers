//
//  ChannelsService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelsServiceProtocol {
  var delegate: ChannelsServiceDelegateProtocol? { get set }
  func addChannel(withName channelName: String)
  func deleteChannel(channel: ChannelMO)
  func fetchChannels()
  func getFRC() -> NSFetchedResultsController<ChannelMO>
}

protocol ChannelsServiceDelegateProtocol: class {
  func processError(with message: String)
  func didFinishDeleting()
}

class ChannelsService {
  weak var delegate: ChannelsServiceDelegateProtocol?
  private var firebaseService: ChannelsFirebaseServiceProtocol
  private var coreDataService: ChannelsCoreDataServiceProtocol

  init(firebaseService: ChannelsFirebaseServiceProtocol,
       coreDataService: ChannelsCoreDataServiceProtocol) {
    self.firebaseService = firebaseService
    self.coreDataService = coreDataService
    self.firebaseService.delegate = self
  }
}

// MARK: - ChannelsServiceProtocol

extension ChannelsService: ChannelsServiceProtocol {
  func getFRC() -> NSFetchedResultsController<ChannelMO> {
    return coreDataService.getFRC()
  }

  func addChannel(withName channelName: String) {
    firebaseService.addChannel(withName: channelName)
  }

  func deleteChannel(channel: ChannelMO) {
    firebaseService.deleteChannel(channel: channel)
  }

  func fetchChannels() {
    firebaseService.fetchChannels()
  }
}

// MARK: - ChannelsFirebaseServiceDelegateProtocol

extension ChannelsService: ChannelsFirebaseServiceDelegateProtocol {
  func firebaseDidFinishFetching() {
    coreDataService.save(channels: firebaseService.channels)
  }

  func processFirebaseError(with message: String) {
    self.delegate?.processError(with: message)
  }

  func firebaseDidFinishDeleting(channel: ChannelMO) {
    coreDataService.deleteChannel(channel: channel)
    self.delegate?.didFinishDeleting()
  }
}
