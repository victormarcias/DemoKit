//
//  MarvelCharactersViewController.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class MarvelCharactersListViewController: GenericListViewController<
    MarvelCharacterListViewCell,
    MarvelCharactersViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Marvel Characters", comment: "")
        isPaginated = true
    }
}

class MarvelCharactersGridViewController: GenericListViewController<
    MarvelCharacterGridViewCell,
    MarvelCharactersViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Marvel Characters", comment: "")
        itemsPerRow = 3
        isPaginated = true
    }
}
