//
//  GridItemView.swift
//  GenericKit
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
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.layer.shadowColor = UIColor.darkGray.cgColor
        
        let margin = CGFloat(5.0)
        
        imageView.snap.edges()
        
        titleLabel.snap.constraint(.left, offset: margin)
            .constraint(.bottom, offset: -margin)
            .constraint(.right, offset: -margin)
    }
}
