//
//  ChannelsFirebaseService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 12.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

protocol ChannelsFirebaseServiceProtocol {
  var delegate: ChannelsFirebaseServiceDelegateProtocol? { get set }
  var channels: [Channel] { get }
  func addChannel(withName channelName: String)
  func deleteChannel(channel: ChannelMO)
  func fetchChannels()
}

protocol ChannelsFirebaseServiceDelegateProtocol: class {
  func processFirebaseError(with message: String)
  func firebaseDidFinishFetching()
  func firebaseDidFinishDeleting(channel: ChannelMO)
}

class ChannelsFirebaseService {
  weak var delegate: ChannelsFirebaseServiceDelegateProtocol?
  var channels: [Channel] = [Channel]()
  private var firebaseStorage: FirebaseStorageProtocol

  init(firebaseStorage: FirebaseStorageProtocol) {
    self.firebaseStorage = firebaseStorage
  }
}

// MARK: - ChannelsFirebaseServiceProtocol

extension ChannelsFirebaseService: ChannelsFirebaseServiceProtocol {
  func addChannel(withName channelName: String) {
    firebaseStorage.addChannel(with: [ChannelKeys.name: channelName])
  }

  func deleteChannel(channel: ChannelMO) {
    guard let id = channel.identifier else {
      self.delegate?.processFirebaseError(with: "The channel cannot be deleted without an identifier")
      return
    }

    self.firebaseStorage.deleteChannel(with: id) { [weak self] error in
      guard let self = self else { return }

      if let error = error {
        self.delegate?.processFirebaseError(with: "Error while deleting channel, \(error)")
        return
      }
      self.delegate?.firebaseDidFinishDeleting(channel: channel)
    }
  }

  func fetchChannels() {
    DispatchQueue.global(qos: .userInitiated).async {[weak self] in
      guard let self = self else { return }

      self.firebaseStorage.addChannelChangesListener { (result) in
        DispatchQueue.main.async {
          switch result {
          case .failure(let error):
            self.delegate?.processFirebaseError(with: error.localizedDescription)
          case .success(let channels):
            self.channels = channels
            self.delegate?.firebaseDidFinishFetching()
          }
        }
      }
    }
  }
}
