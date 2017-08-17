//
//  SearchTableViewControllerTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

class SearchTableViewControllerTests: XCTestCase {

    var viewController: SearchTableViewController!
    lazy var productApi = ProductServiceMock()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController // swiftlint:disable:this force_cast
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController // swiftlint:disable:this force_cast
        viewController = navigationController.topViewController as! SearchTableViewController // swiftlint:disable:this force_cast
        viewController.productApi = productApi

        UIApplication.shared.keyWindow!.rootViewController = viewController

        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
    }

    func testInitialState() {
        switch viewController.state {
        case .initial:
            break
        default:
            XCTFail("Expected initial state")
        }
    }

    func testInitialBackgroundView() {
        XCTAssertEqual(viewController.tableView.backgroundView, viewController.initialView)
    }
}
