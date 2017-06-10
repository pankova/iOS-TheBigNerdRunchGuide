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
    var color = UIColor(hue: 0, saturation: 1, brightness: 0.9, alpha: 1)
    
    init(beginPoint: CGPoint, endPoint: CGPoint) {
        begin = beginPoint
        end = endPoint
    }
    
    // 17: silver
    mutating func setColor() {
        // sinus theorem help us to khow the angle of line to vertical
        let sinusAlpha = abs(begin.x - end.x) / distanceBetweenPoints(a: begin, b: end)
        let alpha = asin(sinusAlpha) * 180 / CGFloat(Double.pi)
        // set color by line's angle
        let hue = Float(alpha / 90)
        color = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 0.9, alpha: 1)

    }
    
    mutating func updateData(view: UIView, lastTouch: UITouch) {
        // update endPoint and color by last user's moving
        end = lastTouch.location(in: view)
        setColor()
    }
    
    func distanceBetweenPoints(a: CGPoint, b: CGPoint) -> CGFloat {
        return pow(pow(a.x - b.x, 2) + pow(a.y - b.y, 2), 0.5)
    }
}
