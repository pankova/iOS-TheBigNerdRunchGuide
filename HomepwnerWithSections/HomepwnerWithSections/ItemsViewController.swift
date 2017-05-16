//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Pankova Mariya on 22.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    // 9: bronze (Sections)
    var sections = ["Econom", "Business"]
    let bound = 50
    var economItems = [Item]()
    var businessItems = [Item]()
    
    func setDividingOnSectionsByBound() -> [Item] {
        for item in itemStore.allItems {
            if item.valueInDollars < bound {
                economItems.append(item)
            } else {
                businessItems.append(item)
            }
        }
        return economItems
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return economItems.count
        } else {
            return businessItems.count
        }
    }
    // end of task
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                                 for: indexPath)
        let backColor = UIColor(white: 1, alpha: 0.7)
        let itemList: [Item]
        
        if indexPath.section == 0 {
            itemList = economItems
        } else {
            itemList = businessItems
        }
        
        let item = itemList[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        cell.detailTextLabel?.backgroundColor = backColor
        cell.textLabel?.font  = UIFont(name:"Arial", size: 20);
        cell.textLabel?.backgroundColor = backColor
        cell.backgroundColor = backColor
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.insertSections([0,1], with: UITableViewRowAnimation.left)
        tableView.rowHeight = 60
        
        let backView = UIImageView(image: #imageLiteral(resourceName: "Bird"))
        backView.contentMode = .scaleAspectFit
        
        let color = UIColor(red: 1, green: 0.95, blue: 0.85, alpha: 1)
        tableView.backgroundColor = color

        tableView.backgroundView = backView
        tableView.backgroundView?.isOpaque = false
        
        let footerView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        footerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        footerView.textAlignment = .center
        footerView.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        
        
        footerView.text = "No more items!"
        footerView.font = UIFont(name:"Arial", size: 18)

        tableView.tableFooterView = footerView
        self.setDividingOnSectionsByBound()
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int  {
        return self.sections.count
    }
    
    

}
