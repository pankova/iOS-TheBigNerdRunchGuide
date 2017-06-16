//
//  DrawView.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 03.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    var currentLines = [NSValue: Line]()
    var currentCircles = [NSValue: Circle]()
    
    var finishedLines = [Line]()
    var finishedCircles = [Circle]()
    
    let finishedCircleColor = UIColor.orange
    
    var selectedLineIndex: Int?
    var moveRecognizer: UIPanGestureRecognizer!
    var velocity: CGPoint!
    
    override var canBecomeFirstResponder: Bool { return true }
    
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
        //print(#function)
        
        let path = UIBezierPath()
        
        path.lineWidth = line.thickness
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
    
    func deleteLine(sender: AnyObject) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        //print(#function)
        
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
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(line: selectedLine)
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
                currentLines[key]?.updateData(view: self, lastTouch: touch, velocity: velocity)
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
                currentLines[key]?.updateData(view: self, lastTouch: touch, velocity: velocity)
                
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
    
    // MARK: - Some helpers
    
    func getKeyOfPairCircleTouches(touch: UITouch) -> NSValue? {
        for currentCircle in currentCircles {
            if touch == currentCircle.value.firstFingerTouch || touch == currentCircle.value.secondFingerTouch {
                return currentCircle.key
            }
            // else return nothing
        }
        return nil
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
                
            }
        }
        return nil
    }
    
    // MARK: - Gesture Recognizers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(gestureRecognizer:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(gestureRecognizer:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(gestureRecognizer:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.moveLine(gestureRecognizer:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)

    }
    
    let menu = UIMenuController.shared

    func tap(gestureRecognizer: UIGestureRecognizer) {
        
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLineAtPoint(point: point)
        
        if selectedLineIndex != nil {
            becomeFirstResponder()
            
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(self.deleteLine(sender:)))
            menu.menuItems = [deleteItem]
        
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height:2), in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {

        print("Recognized a double tap")
        
        menu.setMenuVisible(false, animated: true)
        
        selectedLineIndex = nil
        currentLines.removeAll(keepingCapacity: false)
        currentCircles.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        finishedCircles.removeAll(keepingCapacity: false)
        
        setNeedsDisplay()
    }
    
    
    func longPress(gestureRecognizer: UIGestureRecognizer) {

        print("Recognized a long press")
        
        menu.setMenuVisible(false, animated: true)
        
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLineAtPoint(point: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll(keepingCapacity: false)
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    func moveLine(gestureRecognizer: UIPanGestureRecognizer) {

        print("Recognized a pan")
        
        menu.setMenuVisible(false, animated: true)
        
        let point = gestureRecognizer.location(in: self)
        let index = indexOfLineAtPoint(point: point)
        
        velocity = gestureRecognizer.velocity(in: self)
        
        if selectedLineIndex == nil {
            return
        }
        
        if index == selectedLineIndex {
            if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                
                finishedLines[index!].begin.x += translation.x
                finishedLines[index!].begin.y += translation.y
                finishedLines[index!].end.x += translation.x
                finishedLines[index!].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                setNeedsDisplay()
            }
        } else {
            selectedLineIndex = nil
            return
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
