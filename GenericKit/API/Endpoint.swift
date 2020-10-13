//
//  Endpoint.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-02-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation

///
/// Endpoint base class
///
open class Endpoint<T: EndpointResponse> {
    
    public typealias ResponseResult = ((T) -> Void)
    public typealias ResponseError = ((_ error: ErrorType?) -> Void)
    public typealias Headers = [String: String]
    public typealias Parameters = [String: Any]
    
    ///
    /// Error types
    ///
    public enum ErrorType: Error {
        case invalidUrl, unknown
    }
    
    ///
    /// Method
    ///
    public enum Method {
        case get, post, put, delete
    }
    
    ///
    /// Path: dynamic urls (caller changes them)
    ///
    public class Path {
        private var values: [Any]
        
        public init(_ values: [Any]?) {
            self.values = values ?? []
        }
        
        public var stringValue: String? {
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
    public init(url: String,
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
    public func request(path: Path? = nil,
                        parameters: Parameters = [:],
                        success: @escaping ResponseResult,
                        failure: @escaping ResponseError)
    {
        // add a path to the URL if any
        let path = path ?? Path([])
        let finalUrl = "\(self.url)\(path.stringValue ?? "")"
        
        // check the URL is valid
        guard let _ = URL(string: finalUrl) else {
            failure(.invalidUrl)
            return
        }
        
        // add more parameters if any
        let allParams = baseParameters + parameters
        
        // create the request
        let request = requestObject(with: finalUrl, headers: headers, parameters: allParams)
        
        // perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    success(T(data: data))
                    return
                }
                failure(.unknown)
            }
        }.resume()
    }
    
    ///
    /// URLRequest composition
    ///
    func requestObject(with url: String,
                       headers: Headers,
                       parameters: Parameters) -> URLRequest
    {
        // parameters
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
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

extension Dictionary where Key == String, Value == Any {
    
    static func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
        var all = [K: V]()
        
        for (key, value) in left { all.updateValue(value, forKey: key) }
        for (key, value) in right { all.updateValue(value, forKey: key) }
        
        return all
    }
}
