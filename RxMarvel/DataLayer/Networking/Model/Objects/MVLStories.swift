//
//  Stories.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

// MARK: - Stories
struct MVLStories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [MVLStoriesItem]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available = "available"
        case collectionURI = "collectionURI"
        case items = "items"
        case returned = "returned"
    }
}

// MARK: - StoriesItem
struct MVLStoriesItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case resourceURI = "resourceURI"
        case name = "name"
        case type = "type"
    }
}
