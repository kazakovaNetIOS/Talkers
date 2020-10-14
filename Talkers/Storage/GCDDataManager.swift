//
//  FileStorage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class GCDDataManager {
  static let shared = GCDDataManager()

  private init() {}

  func saveToFile(profile: UserProfile, completion block: @escaping (_ isError: Bool) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      sleep(2)
      block(true)
      print("GCD")
    }
  }

  func loadFromFile() -> UserProfile {
    // todo
    sleep(5)
    return UserProfile(
      name: "Natalya Kazakova",
      position: "UX/UI designer, web-designer Moscow, IOS-developer Russia")
  }
}
