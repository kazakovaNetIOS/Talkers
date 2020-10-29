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

  init(channelId: String, completionHandler: @escaping () -> Void) {
    reference = reference.document(channelId).collection("messages")
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      self.reference.addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else {
          if let error = error {
            print(error.localizedDescription)
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
            senderName: senderName)
        }

        self.messages = self.messages.sorted { $0.created < $1.created }

        DispatchQueue.main.async {
          completionHandler()
        }

        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let messageRequest = MessagesRequest(coreDataStack: appDelegate.coreDataStack)
        messageRequest.makeRequest(messages: self.messages)
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
