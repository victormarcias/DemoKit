//
//  GridItemView.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-29.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

open class GridItemView: BaseView {
    
    public let imageView = ImageView()
    public let titleLabel = UILabel()
    
    override open func setup() {
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        clipsToBounds = true
        layer.cornerRadius = 6
        
        let margin = CGFloat(5.0)
        
        imageView.snap.edges()
        
        titleLabel.snap.constraint(.left, offset: margin)
            .constraint(.bottom, offset: -margin)
            .constraint(.right, offset: -margin)
    }
}
