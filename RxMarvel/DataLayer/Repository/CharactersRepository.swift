//
//  CharactersRepository.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//
import RxSwift

struct CharactersRepository {
    
    enum Error: Swift.Error {
        case charactersListEmpty
    }
    
    static let shared = CharactersRepository()
    
    fileprivate let charactersService: MarvelApiCharactersService
    
    init(with charactersService: MarvelApiCharactersService = MarvelApiNetworkManager.shared) {
        self.charactersService = charactersService
    }
    
}

extension CharactersRepository: CharactersService {
    
    func getCharacters(order: Character.Order, offset: Int, limit: Int) -> Observable<[Character]> {
        return charactersService
            .getCharacters(order: order.rawValue, offset: offset, limit: limit)
            .flatMap({ (response: MVLCharactersResponse) -> Observable<[Character]> in
                guard let results = response.data?.results, results.count > 0 else {
                    return Observable.error(Error.charactersListEmpty)
                }
                return Observable.just(results.compactMap(Character.init))
            })
    }
    
}
