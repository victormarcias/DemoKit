//
//  MarvelCharacterListViewCell.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit
import GenericKit

class CharacterListViewCell: BaseCollectionViewCell<TableItemView>, GenericListViewCell {
    typealias Model = MarvelCharacter
    
    static var itemSize: CGSize {
        return CGSize(width: 0, height: 120)
    }
    
    override static var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
    
    override static var lineInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func configure(with model: Model) {
        view?.imageView.backgroundColor = UIColor.marvel.black
        view?.imageView.url = model.thumbnail?.imageUrl
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
