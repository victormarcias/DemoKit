//
//  MarvelCharacterListViewCell.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class MarvelCharacterListViewCell: BaseCollectionViewCell<TableListItemView>, GenericListCellView {
    typealias Model = MarvelCharacter
    
    static var itemSize: CGSize {
        return CGSize(width: 320, height: 100)
    }
    
    func configure(with model: Model) {
        if let url = model.thumbnail?.imageUrl {
            view?.imageView.loadFrom(url: url)
        }
        view?.titleLabel.text = model.name
        view?.textLabel.text = model.description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view?.imageView.image = nil
        view?.titleLabel.text = nil
        view?.textLabel.text = nil
    }
}
