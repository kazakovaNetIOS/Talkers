//
//  Profile.swift
//  Talkers
//
//  Created by Natalia Kazakova on 14.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

enum PropertyKey {
  static let name = "name"
  static let position = "position"
  static let avatar = "avatar"
}

enum BackgroundMethod {
  case gcd, operation
}

class Profile: NSObject, NSCoding {
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
  static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("talkers")

  let name: String?
  let position: String?
  let avatar: UIImage?
  var initials: String? {
    guard let name = self.name else { return nil }

    var initials = ""
    name.split(separator: " ").forEach { partOfName in
      initials.append(partOfName.first?.uppercased() ?? "")
    }

    return initials
  }

  init(name: String?, position: String?, avatar: UIImage?) {
    self.name = name
    self.position = position
    self.avatar = avatar
  }

  // MARK: - NSCoding

  required convenience init?(coder: NSCoder) {
    let name = coder.decodeObject(forKey: PropertyKey.name) as? String
    let position = coder.decodeObject(forKey: PropertyKey.position) as? String
    let avatar = coder.decodeObject(forKey: PropertyKey.avatar) as? UIImage

    self.init(name: name, position: position, avatar: avatar)
  }

  func encode(with coder: NSCoder) {
    coder.encode(name, forKey: PropertyKey.name)
    coder.encode(position, forKey: PropertyKey.position)
    coder.encode(avatar, forKey: PropertyKey.avatar)
  }
}
