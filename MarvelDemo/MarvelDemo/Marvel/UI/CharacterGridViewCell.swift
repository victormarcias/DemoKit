//
//  CharacterGridViewCell.swift
//  MarvelDemo
//
//  Created by Victor Marcias on 2019-04-29.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit
import DemoKit

class CharacterGridViewCell: BaseCollectionViewCell<GridItemView>, DemoListViewable {
    typealias Model = MarvelCharacter
    
    static var itemSize: CGSize {
        return CGSize(width: 0, height: 130)
    }
    
    override class var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func configure(with model: MarvelCharacter) {
        view?.imageView.backgroundColor = UIColor.marvel.red
        view?.imageView.url = model.thumbnail?.imageUrl
        view?.titleLabel.text = model.name
    }
    
    func showLineSeparator(_ show: Bool) {
        lineSeparator?.isHidden = !show
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view?.imageView.image = nil
        view?.titleLabel.text = nil
    }
}
