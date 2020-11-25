//
//  PixabayImage.swift
//  Talkers
//
//  Created by Natalia Kazakova on 19.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

struct PixabayImages: Codable {
    
    let total, totalHits: Int?
    let hits: [Hit]?
}
