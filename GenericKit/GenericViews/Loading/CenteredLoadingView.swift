//
//  CenteredLoadingView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-18.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class CenteredLoadingView: UIView, LoadingView {
    
    private let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, size: CGSize = CGSize(width: 60, height: 60)) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Instance from IB not supported.")
    }
    
    func setup() {
        isUserInteractionEnabled = false
        backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .whiteLarge
        addSubview(loadingIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingIndicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        layer.cornerRadius = 15
    }
    
    func hide() {
        loadingIndicator.stopAnimating()
        removeFromSuperview()
    }
    
    func show(on parent: UIView) {
        frame = parent.bounds
        parent.addSubview(self)
        loadingIndicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        loadingIndicator.startAnimating()
    }
}
