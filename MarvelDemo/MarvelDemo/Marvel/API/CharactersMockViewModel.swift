//
//  CharactersViewModel.swift
//  MarvelDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import DemoKit

class CharactersMockViewModel: DemoListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(filter: DemoListFilter,
                  success: @escaping DemoListResult,
                  failure: @escaping DemoListError)
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
                
                var grouped = [[MarvelCharacter]]()
                let alphabet = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
                let letters = alphabet.components(separatedBy: ",")
                
                // group the characters by letter
                for letter in letters {
                    let group = filtered.filter { $0.name?.hasPrefix(letter) == true }
                    grouped.append(group)
                }
                
                success(grouped)
                
            }, failure: { _ in
                failure(nil)
            })
    }
}
