//
//  SimpleTableViewController.swift
//  GenericKit
//
//  Created by Victor Marcias on 2018-08-29.
//  Renamed on 2019-04-26.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//
//  --------------------------------------------------------------------------------
//  Customize the options by inheriting from Option.
//  TableView will be arranged automatically with the Options array.
//  See SimpleTableOption.OptionType for type of Cells you need.
//  Note: custom headers not supported unless overriding UITable methods
//

import UIKit

// MARK: - Protocol

protocol SimpleTable: class {
    var sections: [String] { get }
    var options: [[SimpleTableOption]] { get }
}

// MARK: - Main class

public class SimpleTableViewController: UITableViewController, SimpleTable {
    
    var sections = [String]()
    var options = [[SimpleTableOption]]()
    
    convenience init() {
        self.init(style: .plain)
        
        // basic configuration
        tableView.sectionHeaderHeight = 34
        tableView.rowHeight = 50
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.reuseId)
        
        // remove the back button titles
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // remove extra cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setup()
    }
    
    func setup() {
        // override: set sections/options here
    }
    
    func isIndexPathValid(_ indexPath: IndexPath) -> Bool {
        return options.count > indexPath.section && options[indexPath.section].count > indexPath.item
    }
    
    func optionAtIndexPath(_ indexPath: IndexPath) -> SimpleTableOption {
        return options[indexPath.section][indexPath.item]
    }
    
    func navigateTo(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDatasource

extension SimpleTableViewController {
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < sections.count ? sections[section] : nil
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard isIndexPathValid(indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.reuseId, for: indexPath) as? SimpleTableViewCell else {
            fatalError("Unable to dequeue cell with id \(SimpleTableViewCell.reuseId).")
        }
        
        let option = optionAtIndexPath(indexPath)
        cell.option = option
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SimpleTableViewController {

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard isIndexPathValid(indexPath) else { return }
        
        guard let cell = self.tableView(tableView, cellForRowAt: indexPath) as? SimpleTableViewCell else {
            return
        }
        
        // toggle cells are handle with the UISwitch event
        guard cell.type != .toggle else { return }
        
        // *** if its .selectable type, clear previous selection
        if cell.type == .selectable {
            for option in options[indexPath.section] {
                option.isOn = false
            }
        }
        
        // toggle and perform action of the cell
        let option = optionAtIndexPath(indexPath)
        option.isOn = !option.isOn
        cell.isOn = option.isOn
        option.action?(option)
        
        // *** refresh the whole section for .selectable
        if cell.type == .selectable {
            let sectionsToReload = IndexSet(integer: indexPath.section)
            tableView.reloadSections(sectionsToReload, with: .none)
        }
    }
}

// MARK: - Table Option

class SimpleTableOption {
    
    enum OptionType: Int {
        case text           // informative text
        case disclosure     // continues to another ">"
        case selectable     // unselects the rest "✓"
        case toggle         // toggle independently "( O)" UISwitch
    }
    
    var type: OptionType = .text
    var title: String? = ""
    var subtitle: String? = ""
    var isOn: Bool = false
    
    typealias SimpleTableAction = (_ option: SimpleTableOption) -> Void
    var action: SimpleTableAction? // either this or tableView.didSelectRowAt
    
    convenience init(type: OptionType,
                     title: String = "",
                     subtitle: String = "",
                     action: SimpleTableAction? = nil) {
        self.init()
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    // Will Capitalize and space out
    // eg: "myEnumOption" -> "My Enum Option"
    func prettyEnumName(for key: String) -> String {
        var newString: String = ""
        for eachCharacter in key {
            if (eachCharacter >= "A" && eachCharacter <= "Z") == true {
                newString.append(" ")
            }
            newString.append(eachCharacter)
        }
        return newString.capitalized
    }
}

// MARK: - TableViewCell

private class SimpleTableViewCell: UITableViewCell {
    
    static let reuseId = "SimpleTableOptionViewCell"
    
    var option: SimpleTableOption? {
        didSet {
            guard let option = option else {
                return
            }
            
            textLabel?.numberOfLines = 0
            textLabel?.text = option.title
            
            detailTextLabel?.numberOfLines = 0
            detailTextLabel?.text = option.subtitle
            
            type = option.type
            isOn = option.isOn
            
            accessorySwitchAction = option.action
        }
    }
    
    var type: SimpleTableOption.OptionType = .text {
        didSet {
            switch type {
            case .text:
                accessoryType = .none
                selectionStyle = .none
            case .disclosure:
                accessoryType = .disclosureIndicator
            case .selectable:
                accessoryType = .checkmark
            case .toggle:
                let toggle = UISwitch()
                toggle.addTarget(self, action: #selector(onSwitchPressed), for: .valueChanged)
                accessoryView = toggle
                selectionStyle = .none
            }
        }
    }
    
    var isOn: Bool {
        set {
            switch type {
            case .selectable:
                accessoryType = newValue ? .checkmark : .none
            case .toggle:
                accessorySwitch?.isOn = newValue
            default:
                break
            }
        }
        get {
            switch type {
            case .selectable:
                return accessoryType == .checkmark
            case .toggle:
                return accessorySwitch?.isOn ?? false
            default:
                return false
            }
        }
    }
    
    // MARK: - Toggle Type
    
    var accessorySwitch: UISwitch? {
        if let toggle = accessoryView as? UISwitch {
            return toggle
        }
        return nil
    }
    
    var accessorySwitchAction: SimpleTableOption.SimpleTableAction?
    
    @objc private func onSwitchPressed() {
        if let option = self.option {
            option.isOn = accessorySwitch?.isOn ?? false
            accessorySwitchAction?(option)
        }
    }
    
    // MARK: -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
