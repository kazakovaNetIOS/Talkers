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
  lazy var coreDataStack: CoreDataStack = {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError()
    }
    return appDelegate.coreDataStack
  }()

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

  func startLoading(channelId: String, completionHandler: @escaping () -> Void) {
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
            channelId: channelId,
            content: content,
            created: timestamp.dateValue(),
            senderId: senderId,
            senderName: senderName)
        }

        self.messages = self.messages.sorted { $0.created < $1.created }

        let messageRequest = MessagesRequest(coreDataStack: self.coreDataStack)
        messageRequest.makeRequest(messages: self.messages)

        DispatchQueue.main.async {
          completionHandler()
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
