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

class CharactersListViewController: GenericListViewController<
    CharacterListViewCell,
    CharactersViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("List View", comment: "")
        configuration.isPaginated = true
        configuration.itemsPerRow = 1
        configuration.itemsPerPage = 20
        configuration.isSearchable = true
        configuration.isGrouped = true
    }
}

// MARK: - Grid

class CharactersGridViewController: GenericListViewController<
    CharacterGridViewCell,
    CharactersViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    override func configure() {
        navigationItem.title = NSLocalizedString("Grid View", comment: "")
        configuration.isPaginated = true
        configuration.itemsPerRow = 3
        configuration.itemsPerPage = 33
        configuration.isSearchable = true
    }
}

// MARK: - Mocked

class CharactersMockViewController: GenericListViewController<
    CharacterListViewCell,
    CharactersMockViewModel,
    CenteredLoadingView,
    CenteredErrorView>
{
    let titles = ["Iron Man", "Spider-Man"]
    
    override func configure() {
        navigationItem.title = NSLocalizedString("Mock List", comment: "")
        configuration.isPaginated = false
        configuration.itemsPerRow = 1
        configuration.itemsPerPage = 20
        configuration.isSearchable = true
        configuration.isGrouped = true
    }
    
    override func title(for section: Int) -> String {
        return titles[section]
    }
}
