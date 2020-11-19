//
//  Hit.swift
//  Talkers
//
//  Created by Natalia Kazakova on 19.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

// swiftlint:disable all
struct Hit: Codable {
    let id: Int?
    let pageURL: String?
    let type, tags: String?
    let previewURL: String?
    let previewWidth, previewHeight: Int?
    let webformatURL: String?
    let webformatWidth, webformatHeight: Int?
    let largeImageURL: String?
    let imageWidth, imageHeight, imageSize, views: Int?
    let downloads, favorites, likes, comments: Int?
    let userID: Int?
    let user: String?
    let userImageURL: String?
    let idHash: String?
    let fullHDURL, imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, favorites, likes, comments
        case userID = "user_id"
        case user, userImageURL
        case idHash = "id_hash"
        case fullHDURL, imageURL
    }
}
// swiftlint:enable all
