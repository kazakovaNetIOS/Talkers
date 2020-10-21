//
//  ConversationManager.swift
//  Talkers
//
//  Created by Natalia Kazakova on 20.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

class ConversationsDataManager {
  lazy var db = Firestore.firestore()
  lazy var reference = db.collection("channels")

  private var messages = [Message]()

  init(channelId: String, messagesDidLoad: @escaping () -> Void) {
    reference = reference.document(channelId).collection("messages")
    reference.addSnapshotListener { [weak self] snapshot, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let documents = snapshot?.documents else { return }

      for document in documents {
        guard let content = document.data()["content"] as? String else { return }
        guard let timestamp = document.data()["created"] as? Timestamp else { return }
        guard let senderId = document.data()["senderId"] as? String else { return }
        guard let senderName = document.data()["senderName"] as? String else { return }

        let message = Message(
          content: content,
          created: timestamp.dateValue(),
          senderId: senderId,
          senderName: senderName)

        if self?.messages.firstIndex(of: message) == nil {
          self?.messages.append(message)
          messagesDidLoad()
        }
      }
    }
  }

  func getConversation(by indexPath: IndexPath) -> Message {
    return messages[indexPath.row]
  }

  func getConversationsCount() -> Int {
    return messages.count
  }

  func addMessage(withName message: Message) {
    reference.addDocument(data: message.asDictionary())
  }
}
