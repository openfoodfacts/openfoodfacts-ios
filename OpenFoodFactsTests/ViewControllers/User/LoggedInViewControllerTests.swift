//
//  LoggedInViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 15/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import SafariServices

// swiftlint:disable force_cast
// swiftlint:disable weak_delegate
class LoggedInViewControllerTests: XCTestCase {
    var viewController: LoggedInViewController!
    var childDelegate: ChildDelegateMock!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoggedInViewController.self)) as! LoggedInViewController

        childDelegate = ChildDelegateMock()
        viewController.delegate = childDelegate

        UIApplication.shared.keyWindow!.rootViewController = viewController

        TestHelper.sharedInstance.clearCredentials()

        expect(self.viewController.view).notTo(beNil())
    }

    // MARK: - viewDidLoad
    func testViewDidLoadShouldShowsUsernameInLabelWhenCredentialsPresentInUserDefaults() {
        let username = TestHelper.sharedInstance.createUsernameInUserDefaults()

        viewController.viewDidLoad()

        expect(self.viewController.usernameLabel.text).to(equal(username))
    }

    func testViewDidLoadShouldDismissLoggedInVCWhenCredentialsNotInUserDefaults() {
        viewController.viewDidLoad()

        expect(self.childDelegate.removedChild).toEventuallyNot(beNil(), timeout: 10)
    }

    func testDidTapSignoutButton() {
        TestHelper.sharedInstance.createUsernameInUserDefaults()

        viewController.didTapSignOut(UIButton())

        expect(self.childDelegate.removedChild).toEventuallyNot(beNil(), timeout: 10)
        expect(UserDefaults.standard.string(forKey: "username")).toEventually(beNil(), timeout: 10)
    }

    // MARK: - didTapYourContributionsButton
    func testDidTapYourContributionsButton() {
        let testUsername = "test_user"
        UserDefaults.standard.set(testUsername, forKey: "username")

        viewController.didTapYourContributionsButton(UIButton())

        expect(self.viewController.presentedViewController is SFSafariViewController).to(beTrue())
    }
}
