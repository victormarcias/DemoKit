//
//  MarvelCharactersViewController.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class MarvelCharactersViewController: GenericListViewController<
    MarvelCharacterListViewCell,
    MarvelCharactersViewModel,
    CenteredLoadingView,
    CenteredErrorview>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Marvel Characters", comment: "")
        isPaginated = true
    }
}
