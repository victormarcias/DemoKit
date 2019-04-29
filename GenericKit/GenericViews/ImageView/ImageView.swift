//
//  ImageView.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-29.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public class ImageView: BaseView {
    
    let placeholderImageView = UIImageView()
    let imageView = UIImageView()
    
    var placeholderImage: UIImage? {
        didSet {
            placeholderImageView.image = placeholderImage
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var url: String? {
        didSet {
            if let urlString = url {
                imageView.loadFrom(url: urlString)
            }
        }
    }
    
    override func setup() {
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
