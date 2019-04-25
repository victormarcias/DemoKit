//
//  UIView+Constraints.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

///
/// Extension that mimics SnapKit to a minimal extent
///
extension UIView {
    
    public struct Snap {
        private var view: UIView
        
        init(_ view: UIView) {
            self.view = view
        }
        
        ///
        /// Main constraint snapping method
        ///
        @discardableResult
        func constraint(_ attribute: NSLayoutConstraint.Attribute,
                        to: NSLayoutConstraint.Attribute? = nil,
                        of secondView: UIView? = nil,
                        constant: CGFloat = 0.0,
                        multiplier: CGFloat = 1.0,
                        priority: UILayoutPriority = .required) -> UIView.Snap {
            
            let secondView = secondView ?? self.view.superview
            let constraint = NSLayoutConstraint(item: self.view,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: secondView,
                                                attribute: to ?? attribute,
                                                multiplier: multiplier,
                                                constant: constant)
            constraint.priority = priority
            self.view.superview?.addConstraint(constraint)
            return self
        }
        
        ///
        /// Snaps view to its superview's edges
        ///
        func edges(insets: UIEdgeInsets = .zero) {
            guard let _ = self.view.superview else { return }
            
            constraint(.top, constant: insets.top)
                .constraint(.left, constant: insets.left)
                .constraint(.bottom, constant: -insets.bottom)
                .constraint(.right, constant: -insets.right)
        }
    }
    
    public var snap: Snap {
        return Snap(self)
    }
}
