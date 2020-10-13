//
//  MockResponse.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-05-06.
//

import Foundation

public class MockResponse<T: Decodable> {
    public enum Error {
        case invalidPath, unknown
    }
    
    public typealias MockResult = ([[T]]) -> Void
    public typealias MockError = (_ error: Error?) -> Void
    
    ///
    /// Mock file types
    ///
    public enum FileType: String {
        case json, xml
    }
    
    ///
    /// Reads Mock file and converts to a list of decodable Models
    ///
    public class func readFile(_ path: String,
                               type: FileType = .json,
                               success: @escaping MockResult,
                               failure: @escaping MockError)
    {
        // json file path
        guard let mockPath = Bundle.main.path(forResource: path, ofType: type.rawValue) else {
            failure(.invalidPath)
            return
        }
        
        // json file parse
        do {
            let fileText = try String(contentsOf: URL(fileURLWithPath: mockPath), encoding: .utf8)
            
            switch type {
            case .json:
                let items = try JSONDecoder().decode([T].self, from: fileText.data(using: .utf8)!)
                success([items])
            
            case .xml:
                // some day... (not)
                break
            }
        } catch {
            failure(.unknown)
        }
    }
}
