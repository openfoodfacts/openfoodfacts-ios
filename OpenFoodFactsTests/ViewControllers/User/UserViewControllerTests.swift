//
//  UserViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 15/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

// swiftlint:disable force_cast
class UserViewControllerTests: XCTestCase {
    var viewController: UserViewController!
    var productApi: ProductServiceMock!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
        viewController = tabBarController.viewControllers?[1] as! UserViewController

        productApi = ProductServiceMock()
        viewController.productApi = productApi

        TestHelper.sharedInstance.clearCredentials()

        UIApplication.shared.keyWindow!.rootViewController = viewController

        expect(self.viewController.view).notTo(beNil())
    }

    // MARK: - viewDidLoad
    func testViewDidLoadShouldLoadLoginVCWhenCredentialsNotPresent() {
        viewController.viewDidLoad()

        expect(self.viewController.currentChildVC is LoginViewController).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.view.subviews[1]).toEventually(equal(self.viewController.currentChildVC?.view), timeout: 10)
    }

    func testUserViewControllerShouldLoadLoggedinVCWhenCredentiaArePresent() {
        TestHelper.sharedInstance.createUsernameInUserDefaults()

        viewController.viewDidLoad()

        expect(self.viewController.currentChildVC is LoggedInViewController).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.view.subviews[1]).toEventually(equal(self.viewController.currentChildVC?.view), timeout: 10)
    }

    // MARK: - removeChild
    func testRemoveChild() {
        let childViewController = LoggedInViewController()
        viewController.currentChildVC = childViewController
        viewController.addChildViewController(childViewController)
        viewController.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: viewController)

        viewController.removeChild(childViewController)

        expect(childViewController.view.superview).to(beNil())
        expect(self.viewController.currentChildVC is LoggedInViewController).toEventually(beFalse(), timeout: 10)
    }
}
