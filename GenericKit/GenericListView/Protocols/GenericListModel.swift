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
protocol GenericListItemModel {
    var identifier: String { get }
}

///
/// The List complete model
///
protocol GenericListViewable {
    associatedtype Model: GenericListItemModel
    typealias Result = (_ result: [Model]?) -> Void
    
    init()
    func getItems(_ offset: Int, _ count: Int, completion: @escaping Result)
}
