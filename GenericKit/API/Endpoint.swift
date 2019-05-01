//
//  Endpoint.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-02-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

enum EndpointErrorType: Error {
    case unknown
}

public class Endpoint<T: EndpointResponse> {
    
    typealias ResponseResult = ((T) -> Void)
    typealias ResponseError = ((Error) -> Void)
    typealias Headers = [String: String]
    typealias Parameters = [String: Any]
    
    ///
    /// Method
    ///
    enum Method {
        case get, post, put, delete
    }
    
    ///
    /// Path: dynamic urls (caller changes them)
    ///
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
    
    ///
    /// Main properties
    ///
    let url: String
    let method: Method
    let headers: Headers
    let baseParameters: Parameters
    
    ///
    /// Initializer
    ///
    init(url: String,
         method: Method = .get,
         headers: Headers = [:],
         parameters: Parameters = [:])
    {
        self.url = url
        self.method = method
        self.headers = headers
        self.baseParameters = parameters
    }
    
    ///
    /// Request method
    ///
    func request(parameters: Parameters = [:],
                 success: @escaping ResponseResult,
                 failure: @escaping ResponseError)
    {
        // not the best interface for path but can't change the protocol now
        let path = Path(parameters["path"] as? [Any])
        let finalUrl = "\(self.url)\(path.stringValue ?? "")"
        
        // add more parameters if any
        let allParams = baseParameters + parameters
        
        Alamofire.request(finalUrl, parameters: allParams, headers: headers).responseSwiftyJSON(completionHandler: { response in
            
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

// MARK: - Parameters Merge Helper

private extension Dictionary where Dictionary == Endpoint<EndpointResponse>.Parameters {
    
    static func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
        var all = [K: V]()
        
        for (key, value) in left { all.updateValue(value, forKey: key) }
        for (key, value) in right { all.updateValue(value, forKey: key) }
        
        return all
    }
}
