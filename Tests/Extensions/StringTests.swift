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

    func testAttributeGetWidthHeightFromSVG_HTML() {
        let attribute = AttributeView(frame: CGRect())
        let searchString = """
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><path d="M14 20c-3.864 1.035-6.876-1.464-7-3 2.898-.776 6.224.102 7 3z" fill="#fff"/>
        """
        let contentCGSize = attribute.getSVGdimensions(from: searchString)
        XCTAssertNotNil(contentCGSize)
        XCTAssert(contentCGSize?.width == 24 && contentCGSize?.height == 24)
    }
}
