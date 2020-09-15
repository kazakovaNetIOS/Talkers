//
//  ViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.printInLog("The view of UIViewController was loaded into memory: \(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Logger.printInLog("View Controller moved from disappered or disapperaring to appearing. The view of UIViewController is about to be added to a view hierarchy: \(#function)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.printInLog("View Controller moved from appearing to appeared. The view of UIViewController was added to a view hierarchy: \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.printInLog("The view of UIViewController is about to layout its subviews: \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.printInLog("The view of UIViewController has just laid out its subviews: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.printInLog("View Controller moved from appeared or appearing to disappearing. The view of UIViewController is about to be removed from a view hierarchy: \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.printInLog("View Controller moved from disappearing to disappeared. The view of UIViewController was removed from a view hierarchy: \(#function)")
    }
}

