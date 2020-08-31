//
//  MarvelRepositoryCharactersService.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import RxSwift

protocol CharactersService {
    
    func getCharacters(order: Character.Order, offset: Int, limit: Int) -> Observable<[Character]>
    
}
