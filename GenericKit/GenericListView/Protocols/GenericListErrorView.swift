//
//  GenericListErrorView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

enum GenericListErrorType: Error {
    case empty, unknown
}

protocol GenericListErrorView where Self: UIView {
    init()
    func show(_ view: GenericListErrorType)
}
