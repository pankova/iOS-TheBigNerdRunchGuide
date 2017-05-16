//
//  ItemStore.swift
//  Homepwner
//
//  Created by Pankova Mariya on 22.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [NSObject]()
    
    // 9: silver (Constant Rows)
    init(){
        let item = StubItem(name: "No more items!")
        allItems.append(item)
    }
    // end of task
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.insert(newItem, at: 0)
        return newItem
    }
    
    func removeItem(item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }

        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
}
