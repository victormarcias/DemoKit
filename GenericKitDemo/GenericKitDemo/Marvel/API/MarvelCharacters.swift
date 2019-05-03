//
//  MarvelCharacters.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Item Model

struct MarvelCharacter: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    
    struct Thumbnail: Decodable {
        let path: String?
        let `extension`: String?
        
        var imageUrl: String? {
            if let img = path, let ext = `extension` {
                return "\(img).\(ext)"
            }
            return nil
        }
    }
}

// MARK: - Response

class MarvelCharactersResponse: EndpointResponse {
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

// MARK: - View Model

class MarvelCharactersViewModel: GenericListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(_ offset: Int, _ count: Int, completion: @escaping ([MarvelCharacter]?) -> Void) {
        let params = ["offset": offset, "limit": count]
        
        MarvelAPI.characters.request(parameters: params, success: { response in
            completion(response.items)
        }, failure: { _ in
            completion(nil)
        })
    }
}
