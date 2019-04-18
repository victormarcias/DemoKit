//
//  GenericListModel.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation

///
/// The model for each Item
///
public protocol GenericListItemModel {
    var identifier: String { get }
}

///
/// The List complete model
///
public protocol GenericListViewModel {
    associatedtype ItemModel: GenericListItemModel
    typealias Result = (_ result: [ItemModel]?) -> Void
    
    init()
    func getItems(_ offset: Int, _ count: Int, completion: @escaping Result)
}
