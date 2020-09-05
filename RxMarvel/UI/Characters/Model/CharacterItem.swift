//
//  CharacterItem.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import RxDataSources

enum CharacterItem {
    case loading
    case character(data: Character)
}

extension CharacterItem: IdentifiableType {
    
    var identity: Int {
        switch self {
        case .loading:
            return -1
        case .character(let data):
            return data.id
        }
    }
    
}

extension CharacterItem: Equatable {
    
    static func == (lhs: CharacterItem, rhs: CharacterItem) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.character(let lData), .character(let rData)):
            return lData == rData
        default:
            return false
        }
    }
    
}

struct CharacterSection {
    var header: String?
    var items: [CharacterItem]
}

extension CharacterSection: IdentifiableType, Equatable {
    
    var identity: String? {
        return header
    }
    
}

extension CharacterSection: AnimatableSectionModelType {
    typealias Item = CharacterItem
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
    
}

