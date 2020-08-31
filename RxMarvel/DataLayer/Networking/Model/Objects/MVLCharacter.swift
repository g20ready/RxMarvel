//
//  Character.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

// MARK: - Result
struct MVLCharacter: Codable {
    let id: Int?
    let name: String?
    let resultDescription: String?
    let modified: String
    let thumbnail: MVLThumbnail?
    let resourceURI: String?
    let comics: MVLComics?
    let series: MVLComics?
    let stories: MVLStories?
    let events: MVLComics?
    let urls: [MVLURLElement]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case resultDescription = "description"
        case modified = "modified"
        case thumbnail = "thumbnail"
        case resourceURI = "resourceURI"
        case comics = "comics"
        case series = "series"
        case stories = "stories"
        case events = "events"
        case urls = "urls"
    }
}
