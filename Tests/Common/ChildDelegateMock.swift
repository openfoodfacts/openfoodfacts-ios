//
//  ChildDelegateMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 16/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts

class ChildDelegateMock: ChildDelegate {
    var removedChild: ChildViewController?
    func removeChild(_ child: ChildViewController) {
        removedChild = child
    }
}
