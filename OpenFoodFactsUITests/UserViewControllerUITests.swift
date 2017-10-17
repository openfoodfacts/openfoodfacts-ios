//
//  UserViewControllerUITests.swift
//  OpenFoodFactsUITests
//
//  Created by Andrés Pizá Bückmann on 16/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class UserViewControllerUITests: UITestCase {
    func testlogIn() {
        dynamicStubs.setupStub(url: "/cgi/session.pl", html: "<html>Logged in</html>", method: .POST)

        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        // Sign out if logged in
        if app.staticTexts[", you are logged in."].exists {
            app.buttons["Log Out"].tap()
        }

        logIn()

        let label = app.staticTexts[", you are logged in."]
        waitForElementToAppear(label)
    }

    func testLogOut() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        if !app.staticTexts[", you are logged in."].exists {
            dynamicStubs.setupStub(url: "/cgi/session.pl", html: "<html>Logged in</html>", method: .POST)
            logIn()
        }

        let logOutButton = app.buttons["Log Out"]
        waitForElementToAppear(logOutButton)
        logOutButton.tap()
        let logInButton = app.buttons["Log In"]
        waitForElementToAppear(logInButton)
    }

    func testAlertDisplayedWhenlogInWithoutUsername() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        app.buttons["Log In"].tap()

        addUIInterruptionMonitor(withDescription: "Username is required") { (alert) -> Bool in
            alert.buttons["Ok"].tap()
            return true
        }
    }

    func testAlertDisplayedWhenlogInWithoutPassword() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()

        let username = app.scrollViews.textFields["Username"]
        username.tap()
        username.typeText("test_user")

        app.buttons["Log In"].tap()

        addUIInterruptionMonitor(withDescription: "Password is required") { (alert) -> Bool in
            alert.buttons["Ok"].tap()
            return true
        }
    }

    private func logIn() {
        let username = app.scrollViews.textFields["Username"]
        username.tap()
        username.typeText("test_user")

        let password =  app.scrollViews.secureTextFields["Password"]
        password.tap()
        password.typeText("test_pass")

        app.buttons["Log In"].tap()
    }
}
