//
//  GenericListLoadingView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public protocol LoadingView where Self: UIView {
    init()
    func show(on parent: UIView)
    func hide()
}
