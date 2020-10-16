//
//  DemoListViewModel.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import UIKit

public protocol DemoListViewModel {
    associatedtype Model
    
    typealias DemoListFilter = (search: String?, offset: Int, count: Int)
    typealias DemoListResult = (_ result: [[Model]]) -> Void
    typealias DemoListError = (_ error: Error?) -> Void
    
    init()
    
    func getItems(filter: DemoListFilter,
                  success: @escaping DemoListResult,
                  failure: @escaping DemoListError)
}
