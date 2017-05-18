//
//  WebNerdRanchViewController.swift
//  WorldTrotter
//
//  Created by Pankova Mariya on 12.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit
import WebKit

// 6 bronze: Another Tab (open site)
class WebNerdRanchViewController: UIViewController, WKUIDelegate{
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        // зачем?
        //webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.bignerdranch.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
// end of task
