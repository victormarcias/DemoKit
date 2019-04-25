//
//  TableListItemView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public class TableListItemView: BaseView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let textLabel = UILabel()
    
    override func setup() {
        [imageView, titleLabel, textLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textColor = .darkGray
        
        let spacing = CGFloat(10.0)
        let margin = CGFloat(4.0)
        
        imageView.snap.constraint(.top, offset: margin)
            .constraint(.left, offset: spacing)
            .constraint(.bottom, offset: -margin)
            .constraint(.width, to: .height, of: imageView, offset: -margin * 2)
        
        titleLabel.snap.constraint(.top, offset: margin)
            .constraint(.left, to: .right, of: imageView, offset: spacing)
            .constraint(.bottom, to: .centerY)
            .constraint(.right, offset: -spacing)
        
        textLabel.snap.constraint(.top, to: .centerY)
            .constraint(.left, to: .left, of: titleLabel)
            .constraint(.right, to: .right, of: titleLabel)
            .constraint(.bottom, offset: -margin)
    }
}
