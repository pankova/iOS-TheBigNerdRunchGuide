//
//  ColorPanel.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 16.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit
// 18: platinum
class ColorPickerController: UIViewController {
    var delegate: ColorPickerDelegate?
    
    var colorPanel = ColorPickerView()
    var drawColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = colorPanel
        
        if let colorView = view as ColorPickerView? {
            colorView.onColorPickerNotRequired = {
                self.dismissColorPicker()
            }
        }
    }
    
    override func loadView() {
        view = colorPanel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func dismissColorPicker() {
        let colorView: ColorPickerView? = view as? ColorPickerView
        if colorView != nil {
            drawColor = colorView?.drawColor
            userChooseColor()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func userChooseColor() {
        self.delegate?.colorChoosen(colorPicker: self)
    }
}

