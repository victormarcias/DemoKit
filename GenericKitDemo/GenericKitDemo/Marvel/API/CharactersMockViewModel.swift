//
//  MarvelCharactersViewModel.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import GenericKit

class CharactersMockViewModel: GenericListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(filter: GenericListFilter,
                  success: @escaping GenericListResult,
                  failure: @escaping GenericListError)
    {
        MockResponse<MarvelCharacter>.readFile(
            "MarvelCharacters",
            type: .json,
            success: { result in
                let flat = result.flatMap{ $0 }
                var filtered = flat
                
                // search filter
                if let search = filter.search, !search.isEmpty {
                    filtered = flat.filter {
                        let name = $0.name?.lowercased() ?? ""
                        return name.contains(search.lowercased())
                    }
                }
                
                // split into each hero group
                let ironMan = filtered.filter { $0.name?.contains("Iron Man") == true }
                let spiderMan = filtered.filter { $0.name?.contains("Spider-Man") == true }
                
                success([ironMan, spiderMan])
                
            }, failure: { _ in
                failure(nil)
            })
    }
}
