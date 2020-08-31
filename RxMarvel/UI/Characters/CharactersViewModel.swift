//
//  CharactersViewModel.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CharactersViewModel {
    
    struct Input {
        let reset: PublishRelay<()>
        let more: PublishRelay<()>
    }
    
    struct Output {
        let characters: Driver<[CharacterSection]>
    }
    
    let input: Input
    let output: Output
    
    enum OffsetState {
        case more
        case reset
    }
    
    typealias Offset = (state: OffsetState, offset: Int)
    
    init(charactersService: CharactersService) {
        let reset = PublishRelay<()>()
        let more = PublishRelay<()>()
        
        let limit = 20
        
        let resetState = reset.map { OffsetState.reset }
        let moreState = more.map { OffsetState.more }
        
        let state = Observable.merge(resetState, moreState)
        
        let load = state.scan(Offset(OffsetState.reset, 0), accumulator: { (lastOffset, newOffsetState) in
            switch newOffsetState {
            case .reset:
                return Offset(newOffsetState, 0)
            case .more:
                return Offset(newOffsetState, lastOffset.1 + limit)
            }
        }).startWith((OffsetState.reset, 0)).debug("load")
        
        let characters = load.flatMap { offset in charactersService.getCharacters(order: .name,
                                                                                  offset: offset.1,
                                                                                  limit: limit).map { result in (offset.0, result) } }
            .map { ($0.0, $0.1.map(CharacterItemm.character)) }
            .scan([CharacterItemm](), accumulator: { (previousItems, newItems) in
                switch newItems.0 {
                case .reset:
                    return newItems.1
                case .more:
                    return previousItems + newItems.1
                }
            })
            .map { [CharacterSection(header: "More", items: $0)] }
            .asDriver(onErrorJustReturn: [CharacterSection]())
        
        self.input = Input(reset: reset, more: more)
        self.output = Output(characters: characters)
    }
    
}
