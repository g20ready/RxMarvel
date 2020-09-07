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
        let search: PublishRelay<String>
        let more: PublishRelay<()>
    }
    
    struct Output {
        let characters: Driver<[CharacterSection]>
        let error: Driver<String?>
        let noNetworkError: Driver<()>
    }
    
    let input: Input
    let output: Output
    
    enum OffsetState {
        case empty
        case search(term: String)
        case more
        
        var isEmpty: Bool {
            switch self {
            case .empty:
                return true
            default:
                return false
            }
        }
    }
    
    typealias Offset = (state: OffsetState, term: String, offset: Int)
    
    init(charactersService: CharactersService) {
        let search = PublishRelay<String>()
        let more = PublishRelay<()>()
        
        let limit = 20
        
        let searchState = search.map { $0.count > 0 ? OffsetState.search(term: $0) : OffsetState.empty }
        let moreState = more.map { OffsetState.more }
        
        // Reset the error state when a new search starts
        let errorResetOnSearch = searchState.map { state -> String? in
            switch state {
            case .empty:
                return "Search for something"
            default:
                return nil
            }
        }
        
        let state = Observable.merge(searchState, moreState)
        
        let load = state.scan(Offset(OffsetState.empty, String.empty, 0), accumulator: { (lastOffset, newOffsetState) in
            switch newOffsetState {
            case .empty:
                return Offset(newOffsetState, String.empty, 0)
            case .search(let term):
                return Offset(newOffsetState, term, 0)
            case .more:
                return Offset(newOffsetState, lastOffset.1, lastOffset.2 + limit)
            }
        }).startWith((OffsetState.empty, String.empty, 0))
        
        let loadFrommNetwork = load.filter({ !$0.0.isEmpty})
            .flatMap { offset in
                charactersService.getCharacters(nameStartsWith: offset.1,
                                                order: .name,
                                                offset: offset.2,
                                                limit: limit)
                    .map { result in (offset.0, result) }
                    .materialize()
            }.share()
        
        let loadFromNetworkResult = loadFrommNetwork.compactMap { $0.element }
        let loadFromNetworkError = loadFrommNetwork.compactMap { $0.error }
        
        let charactersOnLoad = loadFromNetworkResult
            .map { ($0.0, $0.1.map(CharacterItem.character)) }
            .scan([CharacterItem](), accumulator: { (previousItems, newItems) in
                switch newItems.0 {
                case .search:
                    return newItems.1
                case .more:
                    return previousItems + newItems.1
                default: // Will never reach since we filter for non empty
                    return [CharacterItem]()
                }
            })
            .map { [CharacterSection(header: "More", items: $0)] }
        
        let emptyCharacters = load.filter { $0.0.isEmpty }.map { _ in [CharacterSection]() }
        
        let errorOnLoad = loadFromNetworkError.map { error -> String? in
            switch error {
            case is NetworkUnreachableError:
                return "Network connection is down"
            case let characterRepositoryError as CharactersRepository.Error:
                switch characterRepositoryError {
                case .charactersListEmpty:
                    return "No results found for the given term."
                }
            default:
                return "An unexpected error has occured"
            }
        }.debug("error", trimOutput: false)
        
        let error = Observable.merge(errorResetOnSearch, errorOnLoad).asDriver(onErrorJustReturn: nil)
        
        let characters = Observable.merge(charactersOnLoad, emptyCharacters)
            .asDriver(onErrorJustReturn: [CharacterSection]())
        
        let noNetworkError = Driver.just(())
        
        self.input = Input(search: search, more: more)
        self.output = Output(characters: characters,
                             error: error,
                             noNetworkError: noNetworkError)
    }
    
}
