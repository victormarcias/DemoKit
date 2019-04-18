//
//  UIView+Constraints.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

extension UIView {
    
    func snapEdgesToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superView = superview else { return }
        
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: insets.top)
        let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1, constant: insets.left)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: -insets.bottom)
        let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1, constant: -insets.right)
        
        superView.addConstraints([top, left, bottom, right])
    }
}
