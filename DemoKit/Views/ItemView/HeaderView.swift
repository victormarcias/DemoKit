//
//  HeaderView.swift
//  DemoKit
//
//  Created by Victor Marcias on 2020-10-12.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static var reuseId: String {
        return NSStringFromClass(self)
    }
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        titleLabel.textAlignment = .left
        titleLabel.snap.edges(insets: UIEdgeInsets(top: 4, left: 14, bottom: 4, right: 14))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
