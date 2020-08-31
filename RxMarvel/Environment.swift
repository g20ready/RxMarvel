//
//  Environment.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

struct Environment {
    
    static let current = Environment()
    
    let publicApiKey: String
    let privateApiKey: String
    
    fileprivate init() {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let keysDictionary = NSDictionary(contentsOfFile: path),
            let publicApiKey = keysDictionary["public_api_key"] as? String,
            let privateApiKey = keysDictionary["private_api_key"] as? String else {
                fatalError("Keys.plist is missing or api keys not defined.")
        }
        self.publicApiKey = publicApiKey
        self.privateApiKey = privateApiKey
    }
    
}

