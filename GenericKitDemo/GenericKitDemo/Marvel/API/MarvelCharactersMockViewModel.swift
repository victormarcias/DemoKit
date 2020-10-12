//
//  MarvelCharactersViewModel.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import GenericKit

class MarvelCharactersMockedViewModel: GenericListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(filter: GenericListFilter,
                  success: @escaping GenericListResult,
                  failure: @escaping GenericListError)
    {
        // Search filter
        if let search = filter.search, !search.isEmpty {
            MockResponse<MarvelCharacter>.readFile(
                "MarvelCharacters",
                type: .json,
                success: { result in
                    let filtered = result.flatMap{ $0 }.filter {
                        let name = $0.name?.lowercased() ?? ""
                        return name.contains(search.lowercased())
                    }
                    
                    // check out of bounds (no more items)
                    success([filtered])
                    
                }, failure: { _ in
                    failure(nil)
                })
        } else {
            // Paginated
            MockResponse<MarvelCharacter>.readFile(
                "MarvelCharacters",
                type: .json,
                success: success,
                failure: { _ in }
            )
        }
    }
}
