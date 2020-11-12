//
//  ChannelsStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ChannelsStorageProtocol {
  var delegate: ChannelsStorageDelegateProtocol? { get set }
  var channels: [Channel] { get }
  func save(channel: Channel)
  func addChannel(withName channelName: String)
  func deleteChannel(channel: Channel)
  func fetchChannels()
}

protocol ChannelsStorageDelegateProtocol: class {
  func processError(with message: String)
  func didFinishFetching()
  func didFinishDeleting()
}
