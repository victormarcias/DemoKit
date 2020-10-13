//
//  ErrorView.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public enum ErrorType: Error {
    case empty, unknown
}

public protocol ErrorView where Self: UIView {
    func show(_ type: ErrorType, on parent: UIView)
    func hide()
}
