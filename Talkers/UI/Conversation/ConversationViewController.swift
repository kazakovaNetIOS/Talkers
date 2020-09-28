//
//  ConversationViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - Instantiation from storybord

extension ConversationViewController {
    static func storyboardInstance() -> ConversationViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ConversationViewController
    }
}
