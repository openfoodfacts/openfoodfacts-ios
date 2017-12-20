//
//  LoginViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 16/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import IQKeyboardManagerSwift
import SafariServices

// swiftlint:disable force_cast
// swiftlint:disable weak_delegate
class LoginViewControllerTests: XCTestCase {
    var viewController: LoginViewController!
    var delegate: UserViewControllerDelegateMock!
    var productApi: ProductServiceMock!

    override func setUp() {
        super.setUp()

        viewController = LoginViewController.loadFromStoryboard(named: StoryboardNames.user) as LoginViewController

        delegate = UserViewControllerDelegateMock()
        viewController.delegate = delegate

        productApi = ProductServiceMock()
        viewController.productApi = productApi

        UIApplication.shared.keyWindow!.rootViewController = viewController

        TestHelper.sharedInstance.clearCredentials()

        expect(self.viewController.view).notTo(beNil())
    }

    // MARK: - viewWillAppear
    func testViewWillAppear() {
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = false

        viewController.viewWillAppear(false)

        expect(IQKeyboardManager.sharedManager().enable).to(beTrue())
        expect(IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor).to(beTrue())
    }

    // MARK: - viewWillDisappear
    func testViewWillDisappear() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true

        viewController.viewWillDisappear(false)

        expect(IQKeyboardManager.sharedManager().enable).to(beFalse())
        expect(IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor).to(beFalse())
    }

    // MARK: - didTapLoginButton
    func testDidTapLoginButton() {
        let username = "test_user"
        let password = "test_password"
        viewController.usernameField.text = username
        viewController.passwordField.text = password

        viewController.didTapLoginButton(UIButton())

        expect(self.productApi.didLogIn).toEventually(beTrue(), timeout: 10)
        expect(self.delegate.dismissCalled).to(beTrue())
    }

    func testDidTapLoginButtonShouldResignUsernameFieldAsFirstResponder() {
        let username = "test_user"
        let password = "test_password"
        viewController.usernameField.text = username
        viewController.passwordField.text = password
        viewController.usernameField.becomeFirstResponder()
        expect(self.viewController.usernameField.isFirstResponder).toEventually(beTrue(), timeout: 10)

        viewController.didTapLoginButton(UIButton())

        expect(self.viewController.usernameField.isFirstResponder).toEventually(beFalse(), timeout: 10)
    }

    func testDidTapLoginButtonShouldResignPasswordFieldAsFirstResponder() {
        let username = "test_user"
        let password = "test_password"
        viewController.usernameField.text = username
        viewController.passwordField.text = password
        viewController.passwordField.becomeFirstResponder()
        expect(self.viewController.passwordField.isFirstResponder).toEventually(beTrue(), timeout: 10)

        viewController.didTapLoginButton(UIButton())

        expect(self.viewController.passwordField.isFirstResponder).toEventually(beFalse(), timeout: 10)
    }

    func testDidTapLoginButtonShouldShowErrorBannerWhenApiReturnsWrongCredentialsError() {
        let username = "user_and_password"
        let password = username
        viewController.usernameField.text = username
        viewController.passwordField.text = password

        viewController.didTapLoginButton(UIButton())

        expect(self.viewController.errorBanner.titleLabel?.text).toEventually(equal("user.alert.wrong-credentials.title".localized), timeout: 10)
        expect(self.viewController.errorBanner.subtitleLabel?.text).toEventually(equal("user.alert.wrong-credentials.subtitle".localized), timeout: 10)
        expect(self.viewController.errorBanner.isDisplaying).toEventually(beTrue(), timeout: 10)
    }

    func testDidTapLoginButtonShouldShowErrorBannerWhenApiReturnsGenericError() {
        let username = "test_error_user"
        let password = "test_password"
        viewController.usernameField.text = username
        viewController.passwordField.text = password
        viewController.usernameField.becomeFirstResponder()
        expect(self.viewController.usernameField.isFirstResponder).toEventually(beTrue(), timeout: 10)

        viewController.didTapLoginButton(UIButton())

        expect(self.viewController.usernameField.isFirstResponder).toEventually(beFalse(), timeout: 10)
        expect(self.viewController.errorBanner.titleLabel?.text).toEventually(equal("user.alert.generic-error.title".localized), timeout: 10)
        expect(self.viewController.errorBanner.subtitleLabel?.text).toEventually(equal("user.alert.generic-error.sutbitlt".localized), timeout: 10)
        expect(self.viewController.errorBanner.isDisplaying).toEventually(beTrue(), timeout: 10)
    }

    func testDidTapLoginButtonShowAlertWhenUsernameNotPresent() {
        viewController.didTapLoginButton(UIButton())

        expect(self.viewController.presentedViewController is UIAlertController).toEventually(beTrue())
        let alertController = self.viewController.presentedViewController as! UIAlertController
        expect(alertController.title).to(equal("user.alert.username-missing".localized))
        expect(alertController.actions[0].title).to(equal("alert.action.ok".localized))
    }

    func testDidTapLoginButtonShowAlertWhenPasswordNotPresent() {
        viewController.usernameField.text = "test"

        viewController.didTapLoginButton(UIButton())

        expect(self.viewController.presentedViewController is UIAlertController).toEventually(beTrue(), timeout: 10)
        let alertController = self.viewController.presentedViewController as! UIAlertController
        expect(alertController.title).to(equal("user.alert.password-missing".localized))
        expect(alertController.actions[0].title).to(equal("alert.action.ok".localized))
    }

    // MARK: - didTapCreateAccountButton
    func testDidTapCreateAccountButton() {
        viewController.didTapCreateAccountButton(UIButton())

        expect(self.viewController.presentedViewController is SFSafariViewController).to(beTrue())
    }
}
