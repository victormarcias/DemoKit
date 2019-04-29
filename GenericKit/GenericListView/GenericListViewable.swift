//
//  GenericListViewable.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public protocol GenericListCellView where Self: UICollectionViewCell {
    associatedtype Model
    
    // if width or height is zero, will be adjusted dynamically
    static var itemSize: CGSize { get }
    
    func configure(with model: Model)
}

public protocol GenericListViewModel {
    associatedtype Model
    
    typealias Result = (_ result: [Model]?) -> Void
    
    init()
    func getItems(_ offset: Int, _ count: Int, completion: @escaping Result)
}
