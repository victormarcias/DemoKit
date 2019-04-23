//
//  MarvelAPI.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Endpoint list

struct MarvelAPI {
    static let baseUrl = "https://gateway.marvel.com"
    
    static let characters = MarvelEndpoint<MarvelCharactersResponse>(url: baseUrl + "/v1/public/characters")
}

// MARK: - Endpoint subclass

private struct MarvelParameters {
    static let privateKey = "dd32568cdb058c0bdc0481d1ef9f138f82fce40a"
    static let publicKey = "570fd13a17ad48227232fc46396e67d0"
    static let ts = Date().timeIntervalSince1970.description
    static let hash = "\(ts)\(privateKey)\(publicKey)".md5()
    static let headers = ["Accept-Encoding": "gzip"]
}

class MarvelEndpoint<T: EndpointResponse>: Endpoint<T> {
    
    override init(url: String, method: HTTPMethod = .get, headers: HTTPHeaders = [:]) {
        super.init(url: url, method: method, headers: MarvelParameters.headers)
    }
    
    override func getData(parameters: [String : Any]?,
                          success: @escaping Endpoint<T>.EndpointResult,
                          failure: @escaping Endpoint<T>.EndpointError) {
        var params = parameters ?? [String: Any]()
        params["apikey"] = MarvelParameters.publicKey
        params["ts"] = MarvelParameters.ts
        params["hash"] = MarvelParameters.hash
        
        super.getData(parameters: params,
                      success: { result in
                        success(T(data: result.data))
                      },
                      failure: failure)
    }
}
