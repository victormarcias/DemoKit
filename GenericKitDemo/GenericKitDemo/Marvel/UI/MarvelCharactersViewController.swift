//
//  MarvelCharactersViewController.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-23.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit
import GenericKit

// MARK: - List

class MarvelCharactersListViewController: GenericListViewController<
    MarvelCharacterTableViewCell,
    MarvelCharactersViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Marvel Characters", comment: "")
        isPaginated = true
        itemsPerPage = 20
    }
}

// MARK: - Grid

class MarvelCharactersGridViewController: GenericListViewController<
    MarvelCharacterGridViewCell,
    MarvelCharactersViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Marvel Characters", comment: "")
        isPaginated = true
        itemsPerRow = 3
        itemsPerPage = 40
    }
}

// MARK: - Mocked

class MarvelCharactersMockedViewController: GenericListViewController<
    MarvelCharacterTableViewCell,
    MarvelCharactersMockedViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Marvel Characters", comment: "")
        isPaginated = true
        itemsPerPage = 20
    }
}
