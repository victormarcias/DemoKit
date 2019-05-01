//
//  EndpointResponse.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-02-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ResponseProtocol {
    typealias ResponseData = JSON
    
    init(data: ResponseData)
}

public class EndpointResponse: ResponseProtocol {
    private(set) var data: ResponseData
    
    public required init(data: ResponseData) {
        self.data = data
    }
}
