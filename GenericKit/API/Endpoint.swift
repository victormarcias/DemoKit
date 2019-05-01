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

///
/// Endpoint base class
///
public class Endpoint<T: EndpointResponse> {
    
    typealias ResponseResult = ((T) -> Void)
    typealias ResponseError = ((Error) -> Void)
    typealias Headers = [String: String]
    typealias Parameters = [String: Any]
    
    ///
    /// Error types
    ///
    enum ErrorType: Error {
        case invalidUrl, unknown
    }
    
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
        guard let _ = URL(string: url) else { fatalError("Invalid URL.") }
        
        self.url = url
        self.method = method
        self.headers = headers
        self.baseParameters = parameters
    }
    
    ///
    /// Request method
    ///
    func request(path: Path? = nil,
                 parameters: Parameters = [:],
                 success: @escaping ResponseResult,
                 failure: @escaping ResponseError)
    {
        // add a path to the URL if any
        let path = path ?? Path([])
        
        // add more parameters if any
        let allParams = baseParameters + parameters
        
        // create the request
        let request = requestObject(with: url, path: path, parameters: allParams, headers: headers)
        
        // check the final URL is valid
        guard let _ = URL(string: request.url?.absoluteString ?? "") else {
            failure(ErrorType.invalidUrl)
            return
        }
        
        // perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    success(T(data: data))
                    return
                }
                if let error = error {
                    failure(error)
                    return
                }
                failure(ErrorType.unknown)
            }
        }.resume()
    }
    
    ///
    /// URLRequest composition
    ///
    func requestObject(with url: String,
                       path: Path,
                       parameters: Parameters,
                       headers: Headers) -> URLRequest
    {
        // parameters
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        if let path = path.stringValue {
            components.path = path
        }
        
        // request
        var request = URLRequest(url: components.url!)
        
        // headers
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}

// MARK: - Parameters Merge Helper

public extension Dictionary where Key == String, Value == Any {
    
    static func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
        var all = [K: V]()
        
        for (key, value) in left { all.updateValue(value, forKey: key) }
        for (key, value) in right { all.updateValue(value, forKey: key) }
        
        return all
    }
}
