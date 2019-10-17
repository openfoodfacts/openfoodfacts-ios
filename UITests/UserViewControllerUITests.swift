//
//  UserViewControllerUITests.swift
//  OpenFoodFactsUITests
//
//  Created by Andrés Pizá Bückmann on 16/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class UserViewControllerUITests: UITestCase {
    func skiptestlogIn() {
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

    func skiptestLogOut() {
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

    func skiptestAlertDisplayedWhenlogInWithoutUsername() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()
        logOut()

        app.buttons["Log In"].tap()

        addUIInterruptionMonitor(withDescription: "Username is required") { (alert) -> Bool in
            alert.buttons["Ok"].tap()
            return true
        }
    }

    func skiptestAlertDisplayedWhenlogInWithoutPassword() {
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()
        logOut()

        let username = app.scrollViews.textFields["Username"]
        username.tap()
        username.typeText("test_user")

        app.buttons["Log In"].tap()

        addUIInterruptionMonitor(withDescription: "Password is required") { (alert) -> Bool in
            alert.buttons["Ok"].tap()
            return true
        }
    }

    // MARK: - Helper function

    private func logIn() {
        let username = app.scrollViews.textFields["Username"]
        username.tap()
        username.typeText("test_user")

        let password =  app.scrollViews.secureTextFields["Password"]
        password.tap()
        password.typeText("test_pass")

        app.buttons["Log In"].tap()
    }

    private func logOut() {
        if app.staticTexts[", you are logged in."].exists {
            app.buttons["Log Out"].tap()
        }
    }
}
