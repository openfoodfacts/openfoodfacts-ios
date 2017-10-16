//
//  UserViewControllerUITests.swift
//  OpenFoodFactsUITests
//
//  Created by Andrés Pizá Bückmann on 16/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class UserViewControllerUITests: UITestCase {
    func testLogin() {
        dynamicStubs.setupStub(url: "/cgi/session.pl", html: "<html>Logged in</html>", method: .POST)

        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        // Sign out if logged in
        if app.staticTexts[", you are logged in."].exists {
            app.buttons["Sign out"].tap()
        }

        login()

        let label = app.staticTexts[", you are logged in."]
        waitForElementToAppear(label)
    }

    func testLogOut() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        if !app.staticTexts[", you are logged in."].exists {
            dynamicStubs.setupStub(url: "/cgi/session.pl", html: "<html>Logged in</html>", method: .POST)
        }

        app.buttons["Sign out"].tap()
        let loginButton = app.buttons["Login"]
        waitForElementToAppear(loginButton)
    }

    func testAlertDisplayedWhenLoginWithoutUsername() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        app.buttons["Login"].tap()

        addUIInterruptionMonitor(withDescription: "Username is required") { (alert) -> Bool in
            alert.buttons["Ok"].tap()
            return true
        }
    }

    func testAlertDisplayedWhenLoginWithoutPassword() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        let username = app.scrollViews.textFields["Username"]
        username.tap()
        username.typeText("test_user")

        app.buttons["Login"].tap()

        addUIInterruptionMonitor(withDescription: "Password is required") { (alert) -> Bool in
            alert.buttons["Ok"].tap()
            return true
        }
    }

    private func login() {
        let username = app.scrollViews.textFields["Username"]
        username.tap()
        username.typeText("test_user")

        let password =  app.scrollViews.secureTextFields["Password"]
        password.tap()
        password.typeText("test_pass")

        app.buttons["Login"].tap()
    }
}
