//
//  Character.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

struct Character {
    
    enum Order: String {
        case name = "name"
        case nameReversed = "-name"
        case modified = "modified"
        case modifiedReversed = "-modified"
    }
    
    let id: Int
    let name: String
    let avatarImage: String?
}

extension Character: Equatable { }

