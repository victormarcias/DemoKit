//
//  DemoListCollectionView.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class DemoListCollectionView: UICollectionView {
    
    init(frame: CGRect, itemSize: CGSize = .zero) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = itemSize
        
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialization through IB is not supported.")
    }
}
