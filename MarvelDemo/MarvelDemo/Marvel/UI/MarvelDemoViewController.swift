//
//  MarvelDemoViewController.swift
//  MarvelDemo
//
//  Created by Victor Marcias on 2019-04-26.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit
import DemoKit

final class MarvelDemoViewController: SimpleTableViewController {
    
    override func setup() {
        navigationItem.title = "Marvel's Demo"
        tableView.rowHeight = 70
        
        options = [[
            SimpleTableOption(
                type: .disclosure,
                title: "List View",
                subtitle: "/v1/public/characters",
                action: { _ in self.navigateTo(CharactersListViewController()) }
            ),
            SimpleTableOption(
                type: .disclosure,
                title: "Grid View",
                subtitle: "/v1/public/characters",
                action: { _ in self.navigateTo(CharactersGridViewController()) }
            ),
            SimpleTableOption(
                type: .disclosure,
                title: "Grouped List",
                subtitle: "Resources/MarvelCharacters.json",
                action: { _ in self.navigateTo(CharactersMockViewController()) }
            )
            ]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
    }
}
