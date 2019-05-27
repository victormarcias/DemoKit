//
//  ImageView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-29.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

open class ImageView: BaseView {
    
    public let placeholderImageView = UIImageView()
    public let imageView = UIImageView()
    
    var placeholderImage: UIImage? {
        didSet {
            placeholderImageView.image = placeholderImage
        }
    }
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    public var url: String? {
        didSet {
            if let urlString = url {
                imageView.loadFrom(url: urlString)
            }
        }
    }
    
    override public func setup() {
        [placeholderImageView, imageView].forEach {
            addSubview($0)
        }
        
        placeholderImageView.contentMode = .center
        placeholderImageView.image = UIImage(named: "no-image")
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
        placeholderImageView.snap.edges()
        imageView.snap.edges()
    }
}
