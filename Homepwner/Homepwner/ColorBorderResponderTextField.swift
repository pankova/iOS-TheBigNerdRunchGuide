//
//  ColorBorderResponderTextField.swift
//  Homepwner
//
//  Created by Pankova Mariya on 21.05.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ColorBorderResponderTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        let a = super.becomeFirstResponder()
        self.borderStyle = .none
        return a
    }
    
    override func resignFirstResponder() -> Bool {
        self.borderStyle = .line
        super.resignFirstResponder()
        self.borderStyle = .line
        return true
    }
}
