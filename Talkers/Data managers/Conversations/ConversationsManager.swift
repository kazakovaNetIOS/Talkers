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
  public static var mySenderId: String {
    if let storedSenderId = UserDefaults.standard.string(forKey: MessageKeys.senderId) {
      return storedSenderId
    } else {
      let id = UUID().uuidString
      UserDefaults.standard.setValue(id, forKey: MessageKeys.senderId)
      return id
    }
  }

  init(channelId: String, messagesDidLoad: @escaping () -> Void) {
    reference = reference.document(channelId).collection("messages")
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.reference.addSnapshotListener { [weak self] snapshot, error in
        if let error = error {
          print(error.localizedDescription)
          return
        }

        guard let documents = snapshot?.documents else { return }

        for document in documents {
          guard let content = document.data()[MessageKeys.content] as? String else { return }
          guard let timestamp = document.data()[MessageKeys.created] as? Timestamp else { return }
          guard let senderId = document.data()[MessageKeys.senderId] as? String else { return }
          guard let senderName = document.data()[MessageKeys.senderName] as? String else { return }

          let message = Message(
            content: content,
            created: timestamp.dateValue(),
            senderId: senderId,
            senderName: senderName)

          if self?.messages.firstIndex(of: message) == nil {
            self?.messages.append(message)
            DispatchQueue.main.async {
              messagesDidLoad()
            }
          }
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

  func addMessage(with message: Message) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.reference.addDocument(data: message.dictionary)
    }
  }
}
