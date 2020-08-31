//
//  Thumbnail.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

// MARK: - Thumbnail
struct MVLThumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path = "path"
        case thumbnailExtension = "extension"
    }
}
