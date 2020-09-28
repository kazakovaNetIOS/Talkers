//
//  ConversationsListViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Instantiation from storybord

extension ConversationsListViewController {
    static func storyboardInstance() -> ConversationsListViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ConversationsListViewController
    }
}
