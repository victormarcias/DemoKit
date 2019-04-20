//
//  Endpoint.swift
//  Test
//
//  Created by Victor Marcias on 2019-02-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

enum EndpointErrorType: Error {
    case unknown
}

public class Endpoint<T: EndpointResponse> {
    
    typealias EndpointResult = ((T) -> Void)
    typealias EndpointError = ((Error) -> Void)
    
    class Path {
        private var values: [Any]
        
        init(_ values: [Any]?) {
            self.values = values ?? []
        }
        
        var stringValue: String? {
            if values.count > 0 {
                let stringValues = values.map { String(describing: $0) }
                return "/" + stringValues.joined(separator: "/")
            }
            return nil
        }
    }
    
    let url: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    
    init(url: String, method: HTTPMethod = .get, headers: HTTPHeaders = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
    
    func getData(parameters: [String: Any]? = nil,
                 success: @escaping EndpointResult,
                 failure: @escaping EndpointError) {
        
        // not the best interface for path but can't change the protocol now
        let path = Path(parameters?["path"] as? [Any])
        let finalUrl = "\(self.url)\(path.stringValue ?? "")"
        
        Alamofire.request(finalUrl, parameters: parameters, headers: headers).responseSwiftyJSON(completionHandler: { response in
            
            if let data = response.result.value {
                success(T(data: data))
                return
            }
            if let error = response.error {
                failure(error)
                return
            }
            
            failure(EndpointErrorType.unknown)
        })
    }
}
