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
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
