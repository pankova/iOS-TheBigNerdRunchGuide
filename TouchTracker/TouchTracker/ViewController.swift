//
//  ViewController.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 03.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, ColorPickerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view
        
        if let drawView = view as? DrawView {
            drawView.onColorPickerRequired = {
                self.presentColorPicker()
            }
            print(1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if colorPanel != nil {
            colorChoosen(colorPicker: colorPanel!)
        }
        print(2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var colorPanel: ColorPickerController?
    
    func presentColorPicker() {
        colorPanel = ColorPickerController()
        colorPanel?.delegate = self
        if colorPanel != nil {
            colorPanel?.modalPresentationStyle = UIModalPresentationStyle.custom
            colorPanel?.transitioningDelegate = self
            self.present((colorPanel)!, animated: true, completion: nil)
        }
    }
    
    func colorChoosen(colorPicker: ColorPickerController) {
        let color = colorPicker.drawColor
        if let drawView = view as? DrawView {
            if color != nil {
                drawView.userColor = color!
            }
        }
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}

