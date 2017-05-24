//
//  ChooseDateViewController.swift
//  Homepwner
//
//  Created by Pankova Mariya on 24.05.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit
// 13: gold
class ChooseDateViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker!
    var item: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.date = item.dateCreated
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item.dateCreated = datePicker.date
    }
}
