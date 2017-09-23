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

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        didPopToRootViewController = true
        return [UIViewController()]
    }
}
