//
//  LoadProfileOperation.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class LoadProfileOperation: AsyncOperation {
  var profile: Profile?
  private var fileStorage: FileStorageProtocol

  init(fileStorage: FileStorageProtocol) {
    self.fileStorage = fileStorage
  }

  override func main() {
    do {
      profile = try fileStorage.loadFromFile()
    } catch {
      profile = nil
    }
    finish()
  }
}
