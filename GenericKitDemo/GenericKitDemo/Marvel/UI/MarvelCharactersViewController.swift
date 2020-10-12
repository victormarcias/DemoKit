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
        configuration.isPaginated = true
        configuration.itemsPerRow = 1
        configuration.itemsPerPage = 20
        configuration.isSearchable = true
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
        configuration.isPaginated = true
        configuration.itemsPerRow = 3
        configuration.itemsPerPage = 21
        configuration.isSearchable = true
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
        configuration.isPaginated = true
        configuration.itemsPerRow = 1
        configuration.itemsPerPage = 20
        configuration.isSearchable = true
    }
}
