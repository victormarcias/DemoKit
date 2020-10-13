//
//  CharactersResponse.swift
//  MarvelDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import SwiftyJSON
import DemoKit

class CharactersResponse: EndpointResponse {
    typealias Model = MarvelCharacter
    
    var items: [MarvelCharacter] = []
    
    required init(data: Data) {
        do {
            let result = try JSON(data: data)
            if let list = result["data"]["results"].rawString() {
                items = try JSONDecoder().decode([MarvelCharacter].self, from: list.data(using: .utf8)!)
            }
        } catch {
            // Log error
        }
    }
}
