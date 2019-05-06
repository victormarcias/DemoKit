//
//  BaseCollectionViewCell.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

open class BaseCollectionViewCell<T: UIView>: UICollectionViewCell {
    
    private var _view: UIView?
    
    public var view: T? {
        return _view as? T
    }
    
    open class var insets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    private var widthConstraint = NSLayoutConstraint()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    ///
    /// Setup the inner view
    ///
    func setup() {
        // Width constraint makes dynamic height adjustment possible
        widthConstraint = NSLayoutConstraint(item: contentView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: frame.width)
        contentView.addConstraint(widthConstraint)
        
        // add the Template view
        _view = T()
        
        if let view = _view {
            contentView.addSubview(view)
            
            let insets = type(of: self).insets
            view.snap.edges(insets: insets)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Initialization through IB is not supported.")
    }
}
