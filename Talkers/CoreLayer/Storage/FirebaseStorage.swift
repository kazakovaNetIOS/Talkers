//
//  ChannelsFirebaseStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseStorageProtocol {
  func addChannel(with data: [String: String])
  func addMessage(in channelId: String, with data: [String: Any])
  func deleteChannel(with id: String, completion: @escaping (Error?) -> Void)
  func addChannelChangesListener(_ listener: @escaping (Result<[Channel], Error>) -> Void)
  func addMessagesChangesListener(in channelId: String,
                                  with mySenderId: String,
                                  _ listener: @escaping (Result<[Message], Error>) -> Void)
}

class FirebaseStorage {
  private lazy var db = Firestore.firestore()
  private lazy var reference = db.collection("channels")
}

extension FirebaseStorage: FirebaseStorageProtocol {
  func addChannel(with data: [String: String]) {
    self.reference.addDocument(data: data)
  }

  func addMessage(in channelId: String, with data: [String: Any]) {
    self.reference.document(channelId).collection("messages")
      .addDocument(data: data)
  }

  func deleteChannel(with id: String, completion: @escaping (Error?) -> Void) {
    let channelReference = self.reference.document(id)
    channelReference.delete { error in
      if let error = error {
        completion(error)
        return
      }
    }
  }

  func addChannelChangesListener(_ listener: @escaping (Result<[Channel], Error>) -> Void) {
    self.reference.addSnapshotListener {snapshot, error in
      guard let snapshot = snapshot else {
        if let error = error {
          listener(.failure(error))
        }
        return
      }

      let channels = snapshot.documents.compactMap { document -> Channel? in
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

      listener(.success(channels))
    }
  }

  func addMessagesChangesListener(in channelId: String,
                                  with mySenderId: String,
                                  _ listener: @escaping (Result<[Message], Error>) -> Void) {
    self.reference.document(channelId).collection("messages")
      .addSnapshotListener {snapshot, error in
        guard let snapshot = snapshot else {
          if let error = error {
            listener(.failure(error))
          }
          return
        }

        let messages = snapshot.documents.compactMap { document -> Message? in
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

        listener(.success(messages))
      }
  }
}
