//
//  MarvelCharacter.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation

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
                let url = "\(img).\(ext)"
                if url.contains("4c002e0305708.gif") || url.contains("not_available") {
                    return nil
                }
                return url
            }
            return nil
        }
    }
}
