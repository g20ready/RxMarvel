//
//  MarvelApiNetworkManager.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

struct MarvelApiNetworkManager {
    
    fileprivate let configuration = URLSessionConfiguration.default
    fileprivate let session: Alamofire.Session
    
    static let shared = MarvelApiNetworkManager()
    
    fileprivate init() {
        session = Session(configuration: configuration, startRequestsImmediately: true)
    }
    
}

extension MarvelApiNetworkManager: MarvelApiCharactersService {
    
    func getCharacters(order: String, offset: Int, limit: Int) -> Observable<MVLCharactersResponse> {
        return session.rx.request(route: MarvelApiRouter.characters(order: order, offset: offset, limit: limit))
    }
    
}
