//
//  ThemesViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
  var model: ThemesModelProtocol?

  @IBOutlet weak var classicThemeButton: ThemeButton!
  @IBOutlet weak var dayThemeButton: ThemeButton!
  @IBOutlet weak var nightThemeButton: ThemeButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let themeSettings = model?.currentThemeSettings else { return }

    switch themeSettings.theme {
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

    guard let themeSettings = model?.currentThemeSettings else { return }
    changeColorsForTheme(with: themeSettings)
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
    model?.themeDidSelect(with: settings)

    changeColorsForTheme(with: settings)
  }

  func changeColorsForTheme(with settings: ThemeSettings) {
    setNavigationBarForTheme(themeSettings: settings)

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
  static func storyboardInstance() -> ThemesViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
    return navigationController?.topViewController as? ThemesViewController
  }
}
