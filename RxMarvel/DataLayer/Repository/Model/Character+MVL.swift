//
//  Character+MVL.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

extension Character {
    
    init?(character: MVLCharacter) {
        guard let id = character.id,
            let name = character.name else {
            return nil
        }
        self.id = id
        self.name = name
        if let path = character.thumbnail?.path,
            let thumbnailExtension = character.thumbnail?.thumbnailExtension {
            self.avatarImage = "\(path).\(thumbnailExtension)".replacingOccurrences(of: "http", with: "https")
        } else {
            self.avatarImage = nil
        }
    }
    
}
