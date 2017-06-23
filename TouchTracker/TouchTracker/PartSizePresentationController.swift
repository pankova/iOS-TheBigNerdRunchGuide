//
//  PartSizePresentationController.swift
//  TouchTracker
//
//  Created by Pankova Mariya on 22.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class PartSizePresentationController : UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let screenheight = containerView!.bounds.height
        let viewHeight = screenheight/4
        return CGRect(x: 5, y: screenheight - viewHeight - 5, width: containerView!.bounds.width-10, height: viewHeight)
    }
}
