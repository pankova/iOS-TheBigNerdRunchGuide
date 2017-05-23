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
        self.borderStyle = .line
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.borderStyle = .none
        return super.resignFirstResponder()
    }
}
