//
//  Comics.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

// MARK: - Comics
struct MVLComics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [MVLComicsItem]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available = "available"
        case collectionURI = "collectionURI"
        case items = "items"
        case returned = "returned"
    }
}

// MARK: - ComicsItem
struct MVLComicsItem: Codable {
    let resourceURI: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case resourceURI = "resourceURI"
        case name = "name"
    }
}
