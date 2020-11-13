//
//  MessagesFirebaseService.swift
//  Talkers
//
//  Created by Natalia Kazakova on 13.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

protocol MessagesFirebaseServiceProtocol {
  var delegate: MessagesFirebaseServiceDelegateProtocol? { get set }
  var messages: [Message] { get }
  func addMessage(with message: Message, in channelId: String)
  func fetchMessages(in channel: ChannelMO, mySenderId: String)
}

protocol MessagesFirebaseServiceDelegateProtocol: class {
  func processFirebaseError(with message: String)
  func firebaseDidFinishFetching(in channel: ChannelMO)
}

class MessagesFirebaseService {
  weak var delegate: MessagesFirebaseServiceDelegateProtocol?
  var messages: [Message] = [Message]()
  private var firebaseStorage: FirebaseStorageProtocol

  init(firebaseStorage: FirebaseStorageProtocol) {
    self.firebaseStorage = firebaseStorage
  }
}

// MARK: - MessagesFirebaseServiceProtocol

extension MessagesFirebaseService: MessagesFirebaseServiceProtocol {
  func addMessage(with message: Message, in channelId: String) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.firebaseStorage
        .getMessageCollectionReference(in: channelId)
        .addDocument(data: message.dictionary)
    }
  }

  func fetchMessages(in channel: ChannelMO, mySenderId: String) {
    guard let channelId = channel.identifier else {
      self.delegate?.processFirebaseError(with: "Error while receiving messages")
      return
    }

    self.firebaseStorage
      .getMessageCollectionReference(in: channelId)
      .addSnapshotListener {[weak self] snapshot, error in
        guard let self = self else { return }

        guard let snapshot = snapshot else {
          if let error = error {
            self.delegate?.processFirebaseError(with: error.localizedDescription)
          }
          return
        }

        self.messages = snapshot.documents.compactMap { document -> Message? in
          guard let content = document.data()[MessageKeys.content] as? String else { return nil }
          guard let timestamp = document.data()[MessageKeys.created] as? Timestamp else { return nil }
          guard let senderId = document.data()[MessageKeys.senderId] as? String else { return nil }
          guard let senderName = document.data()[MessageKeys.senderName] as? String else { return nil }

          return Message(
            content: content,
            created: timestamp.dateValue(),
            senderId: senderId,
            senderName: senderName,
            isMyMessage: senderId == mySenderId)
        }

        self.delegate?.firebaseDidFinishFetching(in: channel)
      }
  }
}
