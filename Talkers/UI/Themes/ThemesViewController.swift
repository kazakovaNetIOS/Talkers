//
//  ThemesViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate {
    func themeSelected(with settings: ThemeSettings)
}

class ThemesViewController: UIViewController {
    
    var delegate: ThemesPickerDelegate?
    var themeSelected: ((_ settings: ThemeSettings) -> Void)?

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
        
        processThemeSelected(with: classicThemeButton.themeSettings)
    }
    
    @IBAction func dayThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        dayThemeButton.isSelected(true)
        
        view.backgroundColor = dayThemeButton.chatBackgroundColor
        
        processThemeSelected(with: dayThemeButton.themeSettings)
    }
    
    @IBAction func nightThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        nightThemeButton.isSelected(true)
        
        view.backgroundColor = nightThemeButton.chatBackgroundColor
        
        processThemeSelected(with: nightThemeButton.themeSettings)
    }
}

// MARK: - Private

private extension ThemesViewController {
    func resetButtonsSelectedState() {
        classicThemeButton.isSelected(false)
        dayThemeButton.isSelected(false)
        nightThemeButton.isSelected(false)
    }
    
    func processThemeSelected(with settings: ThemeSettings) {
        guard let delegate = self.delegate, let themeSelected = self.themeSelected else { return }
        
        delegate.themeSelected(with: settings)
        themeSelected(settings)
    }
}


// MARK: - Instantiation from storybord

extension ThemesViewController {
    static func storyboardInstance(
        delegate: ThemesPickerDelegate,
        onThemeSelectedListener: @escaping (_ settings: ThemeSettings) -> Void) -> ThemesViewController? {
        
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let viewController = navigationController?.topViewController as? ThemesViewController
        
        viewController?.delegate = delegate
        viewController?.themeSelected = onThemeSelectedListener
        
        return viewController
    }
}
