//
//  MarvelDemoViewController.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-26.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class MarvelDemoViewController: SimpleTableViewController {
    
    override func setup() {
        navigationItem.title = "Marvel Demo"
        tableView.rowHeight = 70
        
        options = [[
            SimpleTableOption(type: .disclosure, title: "Character List (Table)", subtitle: "/v1/public/characters", action: { _ in self.navigateTo(MarvelCharactersListViewController())
            }),
            SimpleTableOption(type: .disclosure, title: "Character List (Grid)", subtitle: "/v1/public/characters", action: { _ in self.navigateTo(MarvelCharactersGridViewController())
            })
        ]]
    }
}
