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
    firebaseStorage.reference.addDocument(data: [ChannelKeys.name: channelName])
  }

  func deleteChannel(channel: ChannelMO) {
    guard let id = channel.identifier else {
      self.delegate?.processFirebaseError(with: "The channel cannot be deleted without an identifier")
      return
    }

    let channelReference = self.firebaseStorage.reference.document(id)
    channelReference.delete { [weak self] error in
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

      self.firebaseStorage.reference.addSnapshotListener {[weak self] snapshot, error in
        guard let self = self else { return }

        guard let snapshot = snapshot else {
          if let error = error {
            self.delegate?.processFirebaseError(with: error.localizedDescription)
          }
          return
        }

        self.channels = snapshot.documents.compactMap { document -> Channel? in
          let lastMessage = document[ChannelKeys.lastMessage] as? String
          let timestamp = document[ChannelKeys.lastActivity] as? Timestamp
          let lastActivity = timestamp?.dateValue()
          guard let name = document[ChannelKeys.name] as? String,
                !name.isEmptyOrConsistWhitespaces else { return nil }

          return Channel(identifier: document.documentID,
                         name: name,
                         lastMessage: lastMessage,
                         lastActivity: lastActivity)
        }
        
        DispatchQueue.main.async {
          self.delegate?.firebaseDidFinishFetching()
        }
      }
    }
  }
}
