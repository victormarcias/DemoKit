//
//  CenteredLoadingView.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

open class CenteredLoadingView: BaseView, LoadingView {
    
    private let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override open func setup() {
        isUserInteractionEnabled = false
        loadingIndicator.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.70)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .whiteLarge
        addSubview(loadingIndicator)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        loadingIndicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        loadingIndicator.layer.cornerRadius = 15
    }
    
    public func hide() {
        loadingIndicator.stopAnimating()
        removeFromSuperview()
    }
    
    public func show(on parent: UIView) {
        frame = parent.bounds
        parent.addSubview(self)
        loadingIndicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        loadingIndicator.startAnimating()
    }
}
