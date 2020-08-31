//
//  URLElement.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

// MARK: - URLElement
struct MVLURLElement: Codable {
    let type: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case url = "url"
    }
}
