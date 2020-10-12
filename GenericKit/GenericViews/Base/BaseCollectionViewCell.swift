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
    private var _lineSeparator: UIView? = nil
    
    public var view: T? {
        return _view as? T
    }
    public var lineSeparator: UIView? {
        return _lineSeparator
    }
    
    open class var insets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    open class var lineInsets: UIEdgeInsets {
        return UIEdgeInsets.zero // 1 = "full width"
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
        
        let insets = type(of: self).insets
        
        // add the Template view
        _view = T()
        
        if let view = _view {
            contentView.addSubview(view)
            view.snap.edges(insets: insets)
        }
        
        // line separator
        let lineInsets = type(of: self).lineInsets
        if lineInsets.left > 0 {
            let line = UIView()
            line.frame = CGRect(x: 0, y: -1, width: 1, height: 1/UIScreen.main.scale)
            contentView.addSubview(line)
            
            line.isHidden = false
            line.backgroundColor = UIColor.lightGray
            line.frame = CGRect(x: lineInsets.left,
                                y: bounds.height-1,
                                width: bounds.width-lineInsets.left-lineInsets.right,
                                height: 1/UIScreen.main.scale)
            _lineSeparator = line
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Initialization through IB is not supported.")
    }
}
