//
//  DoubleTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 11/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

class DoubleTests: XCTestCase {
    func testTwoDecimalRounded() {
        let value = 123.456
        XCTAssertEqual(123.46, value.twoDecimalRounded)
    }

    func testAsTwoDecimalRoundedStringShouldRoundUpWithTwoDecimals() {
        let value = 123.456
        XCTAssertEqual("123.46", value.asTwoDecimalRoundedString)
    }

    func testAsTwoDecimalRoundedStringShouldReturnDoubleWithOneDecimal() {
        let value = 123.1
        XCTAssertEqual("123.1", value.asTwoDecimalRoundedString)
    }

    func testAsTwoDecimalRoundedStringShouldNotHaveZeroDecimal() {
        let value = 123.0
        XCTAssertEqual("123", value.asTwoDecimalRoundedString)
    }

    func testAsTwoDecimalRoundedStringShouldHaveLeadingZeroWhenValueAsLeadingZero() {
        let value = 0.789
        XCTAssertEqual("0.79", value.asTwoDecimalRoundedString)
    }
}
