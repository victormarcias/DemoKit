//
//  CharactersViewModel.swift
//  MarvelDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import DemoKit

class CharactersViewModel: DemoListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(filter: DemoListFilter,
                  success: @escaping DemoListResult,
                  failure: @escaping DemoListError)
    {
        var params = ["offset": String(describing: filter.offset),
                      "limit": String(describing: filter.count)]
        
        if let search = filter.search, !search.isEmpty {
            params["nameStartsWith"] = search
        }
        
        MarvelAPI.characters.request(
            parameters: params,
            success: { response in
                success([response.items])
            }, failure: { _ in
                failure(nil)
            })
    }
}
