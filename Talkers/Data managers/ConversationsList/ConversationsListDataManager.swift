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

  func startLoading(channelDidLoad: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.reference.addSnapshotListener {snapshot, error in
        if let error = error {
          print(error.localizedDescription)
          return
        }

        guard let documents = snapshot?.documents else { return }

        for document in documents {
          guard let name = document.data()[ChannelKeys.name] as? String else {
            continue
          }

          let identifier = document.documentID
          let lastMessage = document.data()[ChannelKeys.lastMessage] as? String
          let timeStamp = document.data()[ChannelKeys.lastActivity] as? Timestamp
          let lastActivity = timeStamp?.dateValue()

          let channel = Channel(
            identifier: identifier,
            name: name,
            lastMessage: lastMessage,
            lastActivity: lastActivity)

          guard let index = self?.channels.firstIndex(of: channel) else {
            self?.channels.append(channel)
            DispatchQueue.main.async {
              channelDidLoad()
            }

            continue
          }

          self?.channels.insert(channel, at: index)
          DispatchQueue.main.async {
            channelDidLoad()
          }
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
