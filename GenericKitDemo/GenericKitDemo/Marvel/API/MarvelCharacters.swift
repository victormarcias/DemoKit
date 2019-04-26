//
//  MarvelCharacters.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - Item Model

class MarvelCharacter: Mappable {
    private(set) var id: String?
    private(set) var name: String?
    private(set) var description: String?
    private(set) var thumbnail: Thumbnail?
    
    class Thumbnail: Mappable {
        private var imagePath: String?
        private var imageExtention: String?
        
        var imageUrl: String? {
            if let path = imagePath, let extention = imageExtention {
                return "\(path).\(extention)"
            }
            return nil
        }
        
        required init?(map: Map) {
            imagePath <- map["path"]
            imageExtention <- map["extension"]
        }
        
        func mapping(map: Map) {}
    }
    
    required init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        thumbnail <- map["thumbnail"]
    }
    
    func mapping(map: Map) {}
}

// MARK: - Response

class MarvelCharactersResponse: EndpointResponse {
    private(set) var items = [MarvelCharacter]()
    
    required init(data: ResponseData) {
        super.init(data: data)
        
        if let root = data["data"]["results"].arrayObject as? [[String: Any]] {
            items = Mapper<MarvelCharacter>().mapArray(JSONArray: root)
        }
    }
}

// MARK: - View Model

class MarvelCharactersViewModel: GenericListViewModel {
    typealias Model = MarvelCharacter
    
    required init() {}
    
    func getItems(_ offset: Int, _ count: Int, completion: @escaping ([MarvelCharacter]?) -> Void) {
        MarvelAPI.characters.getData(parameters: ["offset": offset], success: { response in
            completion(response.items)
        }, failure: { _ in
            completion(nil)
        })
    }
}
