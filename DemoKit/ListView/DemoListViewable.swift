//
//  DemoListViewable.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import Foundation
import UIKit

public protocol DemoListViewable where Self: UICollectionViewCell {
    associatedtype Model
    
    // if width or height is zero, will be adjusted dynamically
    static var itemSize: CGSize { get }
    
    func configure(with model: Model)
    func showLineSeparator(_ show: Bool)
}
