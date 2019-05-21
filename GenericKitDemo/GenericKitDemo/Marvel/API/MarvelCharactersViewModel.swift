//
//  MarvelCharactersViewModel.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import GenericKit

// MARK: - View Model

class MarvelCharactersViewModel: GenericListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(from offset: Int,
                  to count: Int,
                  filter: String,
                  completion: @escaping ([MarvelCharacter]?) -> Void)
    {
        var params = ["offset": String(describing: offset),
                      "limit": String(describing: count)]
        
        if !filter.isEmpty {
            params["nameStartsWith"] = filter
        }
        
        MarvelAPI.characters.request(parameters: params, success: { response in
            completion(response.items)
        }, failure: { _ in
            completion(nil)
        })
    }
}

// MARK: - Mocked View Model

class MarvelCharactersMockedViewModel: GenericListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(from offset: Int,
                  to count: Int,
                  filter: String,
                  completion: @escaping ([MarvelCharacter]?) -> Void)
    {
        // Search filter
        if !filter.isEmpty {
            MockResponse<MarvelCharacter>.readFile(
                "MarvelCharacters",
                type: .json,
                count: Int.max, // fetch all
                completion: { result in
                    let filtered = result?.filter {
                        return $0.name?.lowercased().contains(filter.lowercased()) ?? false
                    }
                    
                    // check out of bounds (no more items)
                    let outOfBounds = offset >= filtered?.count ?? 0
                    completion(!outOfBounds ? filtered : [])
                }
            )
        } else {
            // Paginated
            MockResponse<MarvelCharacter>.readFile(
                "MarvelCharacters",
                type: .json,
                offset: offset,
                count: count,
                completion: completion
            )
        }
    }
}
