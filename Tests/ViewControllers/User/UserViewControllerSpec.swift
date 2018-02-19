//
//  UserViewControllerSpec.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 15/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

// swiftlint:disable force_cast
// swiftlint:disable function_body_length
class UserViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: UserViewController!
        var dataManager: DataManagerMock!

        beforeEach {
            dataManager = DataManagerMock()

            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
            viewController = tabBarController.viewControllers?[1] as! UserViewController
            viewController.dataManager = dataManager

            TestHelper.sharedInstance.clearCredentials()
        }

        describe("viewDidLoad()") {
            it("transitions to login vc when credentials not present") {
                TestHelper.sharedInstance.clearCredentials()

                // Force viewDidLoad call
                expect(viewController.view).notTo(beNil())

                expect(viewController.childViewControllers[0] is LoginViewController).toEventually(beTrue(), timeout: 10)
                expect(viewController.view.subviews[2]).toEventually(equal(viewController.childViewControllers[0].view), timeout: 10)
            }

            it("transitions to logged in vc when credentials are present") {
                TestHelper.sharedInstance.createUsernameInUserDefaults()

                // Force viewDidLoad call
                expect(viewController.view).notTo(beNil())

                expect(viewController.childViewControllers[0] is UINavigationController).toEventually(beTrue(), timeout: 10)
                let nav = viewController.childViewControllers[0] as! UINavigationController
                expect(nav.childViewControllers[0] is LoggedInViewController).to(beTrue())
            }
        }

        // MARK: - Delegate

        describe("dismiss()") {
            it("transitions to the appropiate vc depending on the state of credentials") {
                TestHelper.sharedInstance.createUsernameInUserDefaults()
                // Force viewDidLoad call
                expect(viewController.view).notTo(beNil())
                TestHelper.sharedInstance.clearCredentials()

                viewController.dismiss()

                expect(viewController.childViewControllers[0] is LoginViewController).toEventually(beTrue(), timeout: 10)
                expect(viewController.view.subviews[2]).toEventually(equal(viewController.childViewControllers[0].view), timeout: 10)
            }
        }

        context("mocked nav controller") {
            var navigationControllerMock: UINavigationControllerMock!
            beforeEach {
                navigationControllerMock = UINavigationControllerMock()
                viewController.childNavigationController = navigationControllerMock
            }

            describe("showProductsPendingUpload()") {
                beforeEach {
                    TestHelper.sharedInstance.createUsernameInUserDefaults()

                    // Force viewDidLoad call
                    expect(viewController.view).notTo(beNil())
                }

                it("shows the products pending upload view controller") {
                    viewController.showProductsPendingUpload()

                    expect(navigationControllerMock.pushedViewController is PendingUploadTableViewController).to(beTrue())
                }
            }
        }
    }
}
