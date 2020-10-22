//
//  ConversationsListDataManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 19.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

class ConversationsListDataManager {
  lazy var db = Firestore.firestore()
  lazy var reference = db.collection("channels")

  private var channels = [Channel]()

  func startLoading(completionHandler: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }

      self.reference.addSnapshotListener {snapshot, error in
        guard let snapshot = snapshot else {
          if let error = error {
            print(error.localizedDescription)
          }
          return
        }

        self.channels = snapshot.documents.compactMap { document -> Channel? in
          let lastMessage = document["lastMessage"] as? String
          let timestamp = document["lastActivity"] as? Timestamp
          let lastActivity = timestamp?.dateValue()
          guard let name = document["name"] as? String,
                !name.isEmptyOrConsistWhitespaces else { return nil }

          return Channel(identifier: document.documentID,
                       name: name,
                       lastMessage: lastMessage,
                       lastActivity: lastActivity)
        }

        self.channels = self.channels.sorted { ($0.lastActivity ?? .distantPast) > ($1.lastActivity ?? .distantPast) }

        DispatchQueue.main.async {
          completionHandler()
        }
      }
    }
  }

  func getConversation(by indexPath: IndexPath) -> Channel {
    return channels[indexPath.row]
  }

  func getConversationsCount() -> Int {
    return channels.count
  }

  func addChannel(withName channelName: String) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.reference.addDocument(data: [ChannelKeys.name: channelName])
    }
  }
}
