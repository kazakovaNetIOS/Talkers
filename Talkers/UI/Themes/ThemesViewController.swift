//
//  ThemesViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var classicThemeButton: ThemeButton!
    @IBOutlet weak var dayThemeButton: ThemeButton!
    @IBOutlet weak var nightThemeButton: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func classicThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        classicThemeButton.isSelected(true)
        view.backgroundColor = classicThemeButton.chatBackgroundColor
    }
    
    @IBAction func dayThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        dayThemeButton.isSelected(true)
        view.backgroundColor = dayThemeButton.chatBackgroundColor
    }
    
    @IBAction func nightThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        nightThemeButton.isSelected(true)
        view.backgroundColor = nightThemeButton.chatBackgroundColor
    }
}

// MARK: - Private

private extension ThemesViewController {
    func resetButtonsSelectedState() {
        classicThemeButton.isSelected(false)
        dayThemeButton.isSelected(false)
        nightThemeButton.isSelected(false)
    }
}


// MARK: - Instantiation from storybord

extension ThemesViewController {
    static func storyboardInstance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        return navigationController?.topViewController as? ThemesViewController
    }
}
