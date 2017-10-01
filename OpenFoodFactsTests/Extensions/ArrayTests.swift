//
//  ArrayTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 01/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
import Nimble

class ArrayTests: XCTestCase {
    // MARK: - append
    func testAppendNewElementShouldNotAddElementWhenElementIsNil() {
        var array = [String]()
        let newElement: String? = nil
        expect(array.count).to(equal(0))
        array.append(newElement)
        expect(array.count).to(equal(0))
    }

    func testAppendNewElementShouldAddElementWhenElementIsNotNil() {
        var array = [String]()
        let newElement: String? = "test"
        expect(array.count).to(equal(0))
        array.append(newElement)
        expect(array.count).to(equal(1))
    }
}
