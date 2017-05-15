//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Pankova Mariya on 06.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahreValue: Double? {
        didSet {
            updateCelsValue()
        }
    }
    
    var celsValue: Double? {
        if let value = fahreValue {
            return (value - 32) * (5/9)
        } else {
            return nil
        }
    }
    
    @IBAction func fahreFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text){
            fahreValue = number.doubleValue
        } else {
            fahreValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func updateCelsValue() {
        if let value = celsValue {
            celsiusLabel.text = "\(value)"
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                                                 replacementString string: String) -> Bool {
        // 4: bronze (Dissallow Alphabetic Characters)
        let set = CharacterSet.decimalDigits
        for characet in string.utf16 {
            // 46 - point, 44 - comma
            if !set.contains(UnicodeScalar(characet)!) && !(characet == 46) && !(characet == 44){
                return false
            }
        }
        // end of task
        
        let currentLocale = Locale.current
        let decimalSeparator = (currentLocale as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Convert loaded")
    }
    
    // 5: silver (Dark Mode depends on user time)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let userHours = dateFormatter.string(from: date)
        
        let color: UIColor
        if Int(userHours)! > 6 && Int(userHours)! < 18 {
            color = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        } else {
            color = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
        }
        self.view.backgroundColor = color
        print(userHours)
    }
    // end of task
}
