//
//  GenericListViewable.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation

///
/// The Model for each Item
///
public protocol GenericListItemModel {
    //
}

///
/// The whole view's ViewModel
///
public protocol GenericListViewable {
    associatedtype ItemModel: GenericListItemModel
    typealias Result = (_ result: [ItemModel]?) -> Void
    
    init()
    func getItems(_ offset: Int, _ count: Int, completion: @escaping Result)
}
