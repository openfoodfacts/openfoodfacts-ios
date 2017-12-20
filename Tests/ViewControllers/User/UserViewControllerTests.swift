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
    }

    // MARK: - viewDidLoad
    func testViewDidLoadShouldLoadLoginVCWhenCredentialsNotPresent() {
        // Force viewDidLoad call
        UIApplication.shared.keyWindow!.rootViewController = viewController
        expect(self.viewController.view).notTo(beNil())

        expect(self.viewController.childViewControllers[0] is LoginViewController).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.view.subviews[2]).toEventually(equal(self.viewController.childViewControllers[0].view), timeout: 10)
    }

    func testUserViewControllerShouldLoadLoggedinVCWhenCredentiaArePresent() {
        TestHelper.sharedInstance.createUsernameInUserDefaults()

        // Force viewDidLoad call
        UIApplication.shared.keyWindow!.rootViewController = viewController
        expect(self.viewController.view).notTo(beNil())

        expect(self.viewController.childViewControllers[0] is LoggedInViewController).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.view.subviews[2]).toEventually(equal(self.viewController.childViewControllers[0].view), timeout: 10)
    }
}
