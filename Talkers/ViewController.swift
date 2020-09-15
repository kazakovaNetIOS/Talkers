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
        
        AppDelegate.printInLog("The view of UIViewController was loaded into memory: \(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.printInLog("The view of UIViewController is about to be added to a view hierarchy: \(#function)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppDelegate.printInLog("The view of UIViewController was added to a view hierarchy: \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        AppDelegate.printInLog("The view of UIViewController is about to layout its subviews: \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        AppDelegate.printInLog("The view of UIViewController has just laid out its subviews: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppDelegate.printInLog("The view of UIViewController is about to be removed from a view hierarchy: \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppDelegate.printInLog("The view of UIViewController was removed from a view hierarchy: \(#function)")
    }
}

