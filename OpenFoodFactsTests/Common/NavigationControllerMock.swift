//
//  NavigationControllerMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 23/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class UINavigationControllerMock: UINavigationController {
    var didPopToRootViewController = false
    var pushedViewController: UIViewController?
    var isViewControllerPushAnimated = false

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        didPopToRootViewController = true
        return super.popToRootViewController(animated: animated)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        self.isViewControllerPushAnimated = animated
        super.pushViewController(viewController, animated: animated)
    }
}
