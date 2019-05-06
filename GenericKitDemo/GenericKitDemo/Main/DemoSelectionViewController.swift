//
//  DemoSelectionViewController.swift
//  GenericKitDemo
//
//  Created by Victor Marcias on 2019-04-26.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit
import GenericKit

class DemoSelectionViewController: SimpleTableViewController {
    
    override func setup() {
        navigationItem.title = "Generic Kit Demo"
        
        options = [[
            SimpleTableOption(
                type: .disclosure,
                title: "Marvel API",
                action: { _ in self.navigateTo(MarvelDemoViewController())})
        ]]
    }
}
