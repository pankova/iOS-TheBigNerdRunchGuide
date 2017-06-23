//
//  Circle.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 04.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

// 17: gold
struct Circle {
    var center = CGPoint.zero
    var radius = CGFloat(0)
    let firstFingerTouch: UITouch
    let secondFingerTouch: UITouch
    var color = UIColor.red
    
    init(view: UIView, firstTouch: UITouch, secondTouch: UITouch) {
        firstFingerTouch = firstTouch
        secondFingerTouch = secondTouch
        updateData(view: view)
    }
    
    mutating func updateData(view: UIView) {
        // update circle center and radius by last user's moving
        let locationX = firstFingerTouch.location(in: view)
        let locationY = secondFingerTouch.location(in: view)
        
        radius = circleRadius(a: locationX, b: locationY)
        center = circleCenter(a: locationX, b: locationY)
    }
    
    func circleRadius(a: CGPoint, b: CGPoint) -> CGFloat {
        return (pow(pow(a.x - b.x, 2) + pow(a.y - b.y, 2), 0.5) / 2.0)
    }
    
    func circleCenter(a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: (a.x + b.x)/2, y: (a.y + b.y)/2)
    }
    
    mutating func setUserColor(color: UIColor) {
        self.color = color
    }
}
