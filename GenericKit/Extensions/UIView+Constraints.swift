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
                        relation: NSLayoutConstraint.Relation = .equal,
                        offset: CGFloat = 0.0,
                        multiplier: CGFloat = 1.0,
                        priority: UILayoutPriority = .required) -> UIView.Snap {
            
            guard let superView = self.view.superview else {
                fatalError("\(self.view) is not in the view hierarchy.")
            }
            
            // assumed to anchor to superview by default if no second view is specified
            let secondView = secondView ?? superView
            let constraint = NSLayoutConstraint(item: self.view,
                                                attribute: attribute,
                                                relatedBy: relation,
                                                toItem: secondView,
                                                attribute: to ?? attribute,
                                                multiplier: multiplier,
                                                constant: offset)
            constraint.priority = priority
            superView.addConstraint(constraint)
            
            // return itself to concatenate constraints
            return self
        }
        
        ///
        /// Snaps view to its superview's edges
        ///
        func edges(insets: UIEdgeInsets = .zero) {
            guard let _ = self.view.superview else {
                fatalError("\(self.view) is not in the view hierarchy.")
            }
            
            constraint(.top, offset: insets.top)
                .constraint(.left, offset: insets.left)
                .constraint(.bottom, offset: -insets.bottom)
                .constraint(.right, offset: -insets.right)
        }
        
        func edges(inset: Double) {
            let value = CGFloat(inset)
            edges(insets: UIEdgeInsets(top: value, left: value, bottom: value, right: value))
        }
    }
    
    public var snap: Snap {
        // if using AutoLayout constraints, disable autoresizing masks
        self.translatesAutoresizingMaskIntoConstraints = false
        return Snap(self)
    }
}
