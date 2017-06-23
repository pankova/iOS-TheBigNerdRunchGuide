//
//  Line.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 03.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var color = UIColor.red //UIColor(hue: 0, saturation: 1, brightness: 0.9, alpha: 1)
    var thickness = CGFloat(0)
    
    
    init(beginPoint: CGPoint, endPoint: CGPoint) {
        begin = beginPoint
        end = endPoint
    }
    
    // 17: silver
    mutating func setColorByAngle() {
        // sinus theorem help us to khow the angle of line to vertical
        let sinusAlpha = abs(begin.x - end.x) / distanceBetweenPoints(a: begin, b: end)
        let alpha = asin(sinusAlpha) * 180 / CGFloat(Double.pi)
        // set color by line's angle
        let hue = Float(alpha / 90)
        color = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 0.9, alpha: 1)
    }
    
    func distanceBetweenPoints(a: CGPoint, b: CGPoint) -> CGFloat {
        return pow(pow(a.x - b.x, 2) + pow(a.y - b.y, 2), 0.5)
    }
    //
    
    mutating func updateData(view: UIView, lastTouch: UITouch, velocity: CGPoint) {
        // update endPoint and color by last user's moving
        end = lastTouch.location(in: view)
        //setColorByAngle()
        setThickness(velocity: velocity)
    }
    
    mutating func setThickness(velocity: CGPoint) {
        thickness = pow(pow(velocity.x,2) + pow(velocity.y, 2), 0.5) / 50
    }
    
    mutating func setUserColor(color: UIColor) {
        self.color = color
    }
}
