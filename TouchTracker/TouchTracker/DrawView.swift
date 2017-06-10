//
//  DrawView.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 03.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines = [NSValue: Line]()
    var currentCircles = [NSValue: Circle]()
    
    var finishedLines = [Line]()
    var finishedCircles = [Circle]()
    
    let finishedCircleColor = UIColor.orange
    
    // theese options you can see in Main.storyboard (Identify Inspector of DrawView)
    @IBInspectable var currentCircleColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Draw functions
    func strokeLine(line: Line) {
        print(#function)
        
        let path = UIBezierPath()
        
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func strokeCircle(circle: Circle) {
        print(#function)
        
        let circlePath = UIBezierPath(arcCenter: circle.center, radius: circle.radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi*2), clockwise: true)
        
        circlePath.lineWidth = lineThickness
        circlePath.move(to: circle.center)
        circlePath.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        print(#function)
        
        for i in 0..<finishedLines.count {
            finishedLines[i].color.setStroke()
            strokeLine(line: finishedLines[i])
        }
        finishedCircleColor.setStroke()
        for i in 0..<finishedCircles.count {
            strokeCircle(circle: finishedCircles[i])
        }
        for (_, line) in currentLines {
            line.color.setStroke()
            strokeLine(line: line)
            
        }
        currentCircleColor.setStroke()
        for (_, circle) in currentCircles {
            strokeCircle(circle: circle)
        }
    }
    
    // MARK: - DrawView lifecycle
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print (#function)
        
        if touches.count == 2 {
            // it is a circle
            let touchArray = Array<UITouch>(touches)
            let newCircle = Circle(view: self, firstTouch: touchArray[0], secondTouch: touchArray[1])
            
            let key = NSValue(nonretainedObject: newCircle)
            currentCircles[key] = newCircle
        } else {
            // it is a line
            for touch in touches {
                let location = touch.location(in: self)
                let newLine = Line(beginPoint: location, endPoint: location)
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print (#function)
        
        for touch in touches {
            if let key = getKeyOfPairCircleTouches(touch:  touch) {
                // it is the circle
                currentCircles[key]?.updateData(view: self)
            } else {
                // it is the line
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.updateData(view: self, lastTouch: touch)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print (#function)
        
        for touch in touches {
            if let key = getKeyOfPairCircleTouches(touch:  touch) {
                // it is the circle
                currentCircles[key]?.updateData(view: self)
                
                if currentCircles[key] != nil {
                    finishedCircles.append(currentCircles[key]!)
                }
                currentCircles.removeValue(forKey: key)
                
            } else {
                // it is the line
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.updateData(view: self, lastTouch: touch)
                
                if currentLines[key] != nil {
                    finishedLines.append(currentLines[key]!)
                }
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentCircles.removeAll()
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    func getKeyOfPairCircleTouches(touch: UITouch) -> NSValue? {
        for currentCircle in currentCircles {
            if touch == currentCircle.value.firstFingerTouch || touch == currentCircle.value.secondFingerTouch {
                return currentCircle.key
            }
            // else return nothing
        }
        return nil
    }
}
