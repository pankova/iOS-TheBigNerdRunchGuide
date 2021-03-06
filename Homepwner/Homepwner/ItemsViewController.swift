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
    var imageStore: ImageStore!
    
    
    // MARK: - View life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 9: gold (Customizing the table)
        let backView = UIImageView(image: #imageLiteral(resourceName: "Bird"))
        backView.contentMode = .scaleAspectFit
        
        let color = UIColor(red: 1, green: 0.95, blue: 0.85, alpha: 1)
        tableView.backgroundColor = color
        
        tableView.backgroundView = backView
        tableView.backgroundView?.isOpaque = false
        // end of task
        
        //tableView.rowHeight = 65 better do this:
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        print("Bundle: \(Bundle.main.bundlePath)")
        
    }
    
    
    // MARK: - Implement UITableViewController methods
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
                cell.textLabel?.font = UIFont(name:"Arial", size: 18)
                cell.textLabel?.textAlignment = .center
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
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
            let backColor = UIColor(white: 1, alpha: 0.7)
            cell.backgroundColor = backColor

            return cell
        }
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
                                                    self.imageStore.deleteImageForKey(key: baseItem.itemKey)
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
    
    // set constant row no editing mode
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == (itemStore.allItems.count - 1) {
            return .none
        }
        return .delete
    }
    
    // 10 silver: Preventing Reordering
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == (itemStore.allItems.count - 1) {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == (itemStore.allItems.count - 1) {
            return false
        }
        return true
    }
    
    
    // MARK: - ButtonActions
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem = itemStore.createItem()
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item as! Item
                detailViewController.imageStore = imageStore
            }
        }
    }
}
