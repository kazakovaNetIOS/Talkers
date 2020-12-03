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
  func fetchMessages(in channelId: String, mySenderId: String)
}

protocol MessagesFirebaseServiceDelegateProtocol: class {
  func processFirebaseError(with message: String)
  func firebaseDidFinishFetching(in channelId: String)
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
    firebaseStorage.addMessage(in: channelId, with: message.dictionary)
  }

  func fetchMessages(in channelId: String, mySenderId: String) {
    self.firebaseStorage.addMessagesChangesListener(in: channelId, with: mySenderId) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error):
          self.delegate?.processFirebaseError(with: error.localizedDescription)
        case .success(let messages):
          self.messages = messages
          self.delegate?.firebaseDidFinishFetching(in: channelId)
        }
      }
    }
  }
}
