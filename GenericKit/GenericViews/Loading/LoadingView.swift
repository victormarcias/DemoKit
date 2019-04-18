//
//  GenericListLoadingView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

protocol LoadingView {
    init()
    func show(on parent: UIView)
    func hide()
}
