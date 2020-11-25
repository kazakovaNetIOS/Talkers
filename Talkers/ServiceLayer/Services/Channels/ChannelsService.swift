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
  var fetchedResultsController: NSFetchedResultsController<ChannelMO> { get }
  func addChannel(withName channelName: String)
  func deleteChannel(channel: ChannelMO)
  func fetchChannels()
}

protocol ChannelsServiceDelegateProtocol: class {
  func processError(with message: String)
}

class ChannelsService {
  weak var delegate: ChannelsServiceDelegateProtocol?
  private var firebaseService: ChannelsFirebaseServiceProtocol
  private var coreDataService: ChannelsCoreDataServiceProtocol
  lazy var fetchedResultsController: NSFetchedResultsController<ChannelMO> = {
    return coreDataService.fetchedResultsController
  }()

  init(firebaseService: ChannelsFirebaseServiceProtocol,
       coreDataService: ChannelsCoreDataServiceProtocol) {
    self.firebaseService = firebaseService
    self.coreDataService = coreDataService
    self.firebaseService.delegate = self
    self.coreDataService.delegate = self
  }
}

// MARK: - ChannelsServiceProtocol

extension ChannelsService: ChannelsServiceProtocol {
  func addChannel(withName channelName: String) {
    firebaseService.addChannel(withName: channelName)
  }

  func deleteChannel(channel: ChannelMO) {
    firebaseService.deleteChannel(channel: channel)
  }

  func fetchChannels() {
    coreDataService.fetchChannels()
  }
}

// MARK: - ChannelsFirebaseServiceDelegateProtocol

extension ChannelsService: ChannelsFirebaseServiceDelegateProtocol {
  func firebaseDidFinishFetching() {
    coreDataService.upsert(firebaseService.channels)
  }

  func processFirebaseError(with message: String) {
    self.delegate?.processError(with: "Error in Firebase, \(message)")
  }

  func firebaseDidFinishDeleting(channel: ChannelMO) {
    coreDataService.deleteChannel(channel: channel)
  }
}

// MARK: - ChannelsCoreDataServiceDelegateProtocol

extension ChannelsService: ChannelsCoreDataServiceDelegateProtocol {
  func processCoreDataError(with message: String) {
    self.delegate?.processError(with: "Error in CoreData, \(message)")
  }

  func coreDataDidFinishFetching() {
    firebaseService.fetchChannels()
  }
}
