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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemStore.allItems[indexPath.row]
        //10:silver
        if indexPath.row == (itemStore.allItems.count - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UIStubViewCell", for: indexPath)
            if let stubItem = item as? StubItem {
                cell.textLabel?.text = stubItem.name
                cell.textLabel?.textAlignment = .center
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! Item
            cell.updateLabels()
            
            if let baseItem = item as? Item {
                //10:gold
                let font = UIFont(name:"Arial", size: 20)
                
                cell.nameLabel.text = baseItem.name
                cell.nameLabel.font = font
                cell.serialNumberLabel.text = baseItem.serialNumber
                cell.valueLabel.text = "\(baseItem.valueInDollars)$"
                //11 bronze
                if baseItem.valueInDollars < 50 {
                    cell.valueLabel.textColor = UIColor.green
                } else {
                    cell.valueLabel.textColor = UIColor.red
                }
                cell.valueLabel.font = font
            }
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        //tableView.rowHeight = 65 better do this:
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            if let baseItem = item as? Item {
                let title = "Delete \(baseItem.name)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                                 handler: { (action) -> Void in
                                                    self.itemStore.removeItem(item: baseItem)
                                                    tableView.deleteRows(at: [indexPath], with: .automatic)
                })
                ac.addAction(deleteAction)
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    //11 gold
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == (itemStore.allItems.count - 1) {
            var allowedPath = proposedDestinationIndexPath
            allowedPath.row -= 1
            return allowedPath
        }
        return proposedDestinationIndexPath
    }
    
    // 10: bronze
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    //11:gold
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == (itemStore.allItems.count - 1) {
            return UITableViewCellEditingStyle.none;
        }
        return UITableViewCellEditingStyle.delete;
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == (itemStore.allItems.count - 1) {
            return false
        }
        return true
    }
        
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem = itemStore.createItem()
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item as! Item
            }
        }
    }
}
