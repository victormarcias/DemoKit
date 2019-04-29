//
//  GridItemView.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-29.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public class GridItemView: BaseView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override func setup() {
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
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
