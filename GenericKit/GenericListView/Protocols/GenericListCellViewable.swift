//
//  GenericListCellViewable.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public protocol GenericListCellViewable where Self: UICollectionViewCell {
    var view: UIView { get }
    static var itemSize: CGSize { get }
    
    func configure(with: GenericListItemModel)
}
