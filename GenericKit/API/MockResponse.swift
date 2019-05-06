//
//  MockResponse.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-05-06.
//

import Foundation

public class MockResponse<T: Decodable> {
    
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
                               offset: Int = 0,
                               count: Int = 0,
                               completion: @escaping (([T]?) -> Void))
    {
        // json file path
        guard let mockPath = Bundle.main.path(forResource: path, ofType: type.rawValue) else {
            completion(nil)
            return
        }
        
        // json file parse
        do {
            let fileText = try String(contentsOf: URL(fileURLWithPath: mockPath), encoding: .utf8)
            
            switch type {
            case .json:
                let items = try JSONDecoder().decode([T].self, from: fileText.data(using: .utf8)!)
                
                // check out of bounds
                let maxItem = min(offset + count, items.count)
                
                // return paginated subset or empty if we went beyond the max
                let subset = Array(items[offset ..< maxItem])
                completion(subset)
            
            case .xml:
                // some day... (not)
                break
            }
        } catch {
            completion(nil)
        }
    }
}
