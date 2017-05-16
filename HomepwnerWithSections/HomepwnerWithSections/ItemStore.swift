//
//  ItemStore.swift
//  Homepwner
//
//  Created by Pankova Mariya on 22.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }

    init() {
        for _ in 0..<15 {
            createItem()
        }
    }
}
