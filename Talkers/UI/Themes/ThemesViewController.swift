//
//  ThemesViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate: class {
  func themeDidSelect(_ themesViewController: ThemesViewController, with settings: ThemeSettings)
}

class ThemesViewController: UIViewController {
    
    weak var delegate: ThemesPickerDelegate?
    var themeSelected: ((_ settings: ThemeSettings) -> Void)?

    @IBOutlet weak var classicThemeButton: ThemeButton!
    @IBOutlet weak var dayThemeButton: ThemeButton!
    @IBOutlet weak var nightThemeButton: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch ThemeManager.shared.themeSettings.theme {
            case .classic:
                classicThemeButton.isSelected(true)
            case .day:
                dayThemeButton.isSelected(true)
            case .night:
                nightThemeButton.isSelected(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeColorsForTheme(with: ThemeManager.shared.themeSettings)
    }
    
    @IBAction func classicThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        classicThemeButton.isSelected(true)
        
        classicThemeButton.themeSettings.theme = .classic
        
        processThemeSelected(with: classicThemeButton.themeSettings)
    }
    
    @IBAction func dayThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        dayThemeButton.isSelected(true)
        
        dayThemeButton.themeSettings.theme = .day
        
        processThemeSelected(with: dayThemeButton.themeSettings)
    }
    
    @IBAction func nightThemeButtonTapped(_ gesture: UITapGestureRecognizer) {
        resetButtonsSelectedState()
        nightThemeButton.isSelected(true)
        
        nightThemeButton.themeSettings.theme = .night
        
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
        
      delegate.themeDidSelect(self, with: settings)
        
        // retain cycle мог бы возникнуть, если бы в это замыкание например, передавалась ссылка на ThemesViewController,
        // а внутри кода замыкания в capture list эта ссылка не была бы помечена как weak.
        // При таком сценарии получалась бы связка сильных ссылок: контроллер ссылается на замыкание,
        // замыкание держит контроллер
        // В моем коде в замыкание передается структура, которая является value-типом и не может образовать
        // цикл сильных ссылок
        themeSelected(settings)
        
        changeColorsForTheme(with: settings)
    }
    
    func changeColorsForTheme(with settings: ThemeSettings) {
        setNavigationBarForTheme()
        
        view.backgroundColor = settings.chatBackgroundColor
        setButtonsLabelColor(color: settings.labelColor)
    }
    
    func setButtonsLabelColor(color: UIColor) {
        classicThemeButton.setDisplayLabelTextColor(with: color)
        dayThemeButton.setDisplayLabelTextColor(with: color)
        nightThemeButton.setDisplayLabelTextColor(with: color)
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
