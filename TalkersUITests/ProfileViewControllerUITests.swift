//
//  ProfileViewControllerUITests.swift
//  ProfileViewControllerUITests
//
//  Created by Natalia Kazakova on 05.12.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import XCTest

class ProfileViewControllerUITests: XCTestCase {

  func testProfileViewController_whenLaunched_nameTextFieldAndPositionTextViewExists() {
    let app = XCUIApplication()
    app.launch()

    app.navigationBars["Channels"].children(matching: .button).element(boundBy: 2).tap()

    let positionTextView = app.textViews["textView--profilePositionTextView"]
    let nameTextField = app.textFields["textField--profileNameField"]

    XCTAssertTrue(positionTextView.exists)
    XCTAssertTrue(nameTextField.exists)
  }
}
