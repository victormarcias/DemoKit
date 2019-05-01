//
//  EndpointResponse.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-02-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation

public protocol EndpointResponse {
    associatedtype Model
    
    var items: [Model] { get }
    
    init(data: Data)
}
