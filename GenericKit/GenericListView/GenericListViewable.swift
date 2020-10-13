//
//  GenericListViewable.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import UIKit

public protocol GenericListViewCell where Self: UICollectionViewCell {
    associatedtype Model
    
    // if width or height is zero, will be adjusted dynamically
    static var itemSize: CGSize { get }
    
    func configure(with model: Model)
    func showLineSeparator(_ show: Bool)
}

public protocol GenericListViewModel {
    associatedtype Model
    
    typealias GenericListFilter = (search: String?, offset: Int, count: Int)
    typealias GenericListResult = (_ result: [[Model]]) -> Void
    typealias GenericListError = (_ error: Error?) -> Void
    
    init()
    
    func getItems(filter: GenericListFilter,
                  success: @escaping GenericListResult,
                  failure: @escaping GenericListError)
}
