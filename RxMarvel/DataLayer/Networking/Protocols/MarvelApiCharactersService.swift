//
//  MarvelApiService.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import RxSwift

protocol MarvelApiCharactersService {
    
    func getCharacters(nameStartsWith: String, order: String, offset: Int, limit: Int) -> Observable<MVLCharactersResponse>
    
}
