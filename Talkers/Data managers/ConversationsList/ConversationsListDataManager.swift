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

  init(channelDidLoad: @escaping () -> Void) {
    reference.addSnapshotListener { [weak self] snapshot, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let documents = snapshot?.documents else { return }

      for document in documents {
        guard let name = document.data()["name"] as? String else { return }

        let identifier = document.documentID
        let lastMessage = document.data()["lastMessage"] as? String
        let timeStamp = document.data()["lastActivity"] as? Timestamp
        let lastActivity = timeStamp?.dateValue()

        let channel = Channel(
          identifier: identifier,
          name: name,
          lastMessage: lastMessage,
          lastActivity: lastActivity)

        if self?.channels.firstIndex(of: channel) == nil {
          self?.channels.append(channel)
          channelDidLoad()
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
    reference.addDocument(data: ["name": channelName])
  }
}
