//
//  ChannelsFirebaseStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
import Firebase

protocol ChannelsFirebaseStorageProtocol {
  var db: Firestore { get }
  var reference: CollectionReference { get }
  func getMessageCollectionReference(in channelId: String) -> CollectionReference
}

class ChannelsFirebaseStorage {
  lazy var db = Firestore.firestore()
  lazy var reference = db.collection("channels")
}

extension ChannelsFirebaseStorage: ChannelsFirebaseStorageProtocol {
  func getMessageCollectionReference(in channelId: String) -> CollectionReference {
    return reference.document(channelId).collection("messages")
  }
}
