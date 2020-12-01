//
//  Hit.swift
//  Talkers
//
//  Created by Natalia Kazakova on 19.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

struct Hit: Codable {
    let previewURL: String?
    let fullHDURL: String?

    enum CodingKeys: String, CodingKey {
        case previewURL
        case fullHDURL
    }
}
