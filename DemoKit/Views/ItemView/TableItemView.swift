//
//  TableListItemView.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

open class TableItemView: BaseView {
    
    public let imageView = ImageView()
    public let titleLabel = UILabel()
    public let textLabel = UILabel()
    
    override open func setup() {
        [imageView, titleLabel, textLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .darkGray
        imageView.layer.cornerRadius = 4
        
        let spacing = CGFloat(10.0)
        let margin = CGFloat(6.0)
        
        imageView.snap.constraint(.top, offset: margin)
            .constraint(.left, offset: spacing)
            .constraint(.bottom, offset: -margin)
            .constraint(.width, to: .height, of: imageView, offset: -spacing)
        
        titleLabel.snap.constraint(.top, relation: .greaterThanOrEqual, offset: margin)
            .constraint(.centerY, to: .centerY, relation: .lessThanOrEqual)
            .constraint(.left, to: .right, of: imageView, offset: spacing)
            .constraint(.right, offset: -spacing)
        
        textLabel.snap.constraint(.top, to: .bottom, of: titleLabel, relation: .greaterThanOrEqual)
            .constraint(.left, to: .left, of: titleLabel)
            .constraint(.right, to: .right, of: titleLabel)
            .constraint(.bottom, relation: .lessThanOrEqual, offset: -margin)
    }
}
