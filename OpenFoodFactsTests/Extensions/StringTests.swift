//
//  StringTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 11/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

class StringTests: XCTestCase {
    func testNSRange() {
        let test = "test"
        let expectedRange = NSRange(location: 0, length: 4)
        XCTAssertEqual(expectedRange, test.nsrange)
    }

    func testIsNumberReturnsTrueWhenStringIsNumber() {
        XCTAssertTrue("2".isNumber())
    }

    func testIsNumberReturnsFalseWhenStringIsNotNumber() {
        XCTAssertFalse("a".isNumber())
    }
}
