//
//  MarvelCharacterGridViewCell.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-29.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class MarvelCharacterGridViewCell: BaseCollectionViewCell<GridItemView>, GenericListCellView {
    typealias Model = MarvelCharacter
    
    static var itemSize: CGSize {
        return .zero
    }
    
    override class var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func configure(with model: MarvelCharacter) {
        view?.imageView.url = model.thumbnail?.imageUrl
        view?.titleLabel.text = model.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view?.imageView.image = nil
        view?.titleLabel.text = nil
    }
}
