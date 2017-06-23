//
//  ColorPickerView.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 18.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ColorPickerView: UIView, UIGestureRecognizerDelegate {
    
    var drawColor: UIColor?
    var onColorPickerNotRequired: (() -> Void)?
    let stackView = UIStackView()
    
    let colorArray: [UIColor] =
        [UIColor.white,
         UIColor.yellow,
         UIColor.cyan,
         UIColor.green,
         UIColor.red,
         UIColor.blue,
         UIColor.brown,
         UIColor.black]
    
    func threeFingerSwipeDown(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a three-finger swipe down")
        self.onColorPickerNotRequired!()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
        backgroundColor = UIColor(hue: 0.3028, saturation: 0, brightness: 0.83, alpha: 1.0)
        
        self.layer.cornerRadius = 10
        setStackViewParams()
        
        for color in colorArray {
            let cell = colorCell()
            cell.backgroundColor = color
            stackView.addArrangedSubview(cell)
        }
        
        let threeSwipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.threeFingerSwipeDown(gestureRecognizer:)))
        threeSwipeDownRecognizer.numberOfTouchesRequired = 1
        threeSwipeDownRecognizer.direction = .down
        addGestureRecognizer(threeSwipeDownRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStackViewParams() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        let xConstraint = NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        let leftConstraint = NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5)
        
        let rightConstraint = NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -5)
        
        addConstraints([xConstraint])
        addConstraints([yConstraint])
        addConstraints([leftConstraint])
        addConstraints([rightConstraint])
    }
    
    func colorCell() -> UIButton {
        let colorCell = UIButton()
        colorCell.frame.size = CGSize(width: 20, height: 100)
        colorCell.layer.borderWidth = 2
        colorCell.layer.borderColor = UIColor(hue: 0.3194, saturation: 0, brightness: 0.69, alpha: 1.0).cgColor
        colorCell.layer.cornerRadius = 7
        colorCell.addTarget(self, action: #selector(ColorPickerView.colorButtonAction(_:)), for: .touchUpInside)
        
        return colorCell
    }
    
    func colorButtonAction(_ sender: UIButton!) {
        for cell in stackView.arrangedSubviews {
            cell.layer.borderWidth = 2
        }
        sender.layer.borderWidth = 4
        drawColor = sender.backgroundColor
        print("Color is: \(String(describing: drawColor))")
    }
}
