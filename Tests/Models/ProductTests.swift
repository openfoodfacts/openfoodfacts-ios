//
//  ProductTests.swift
//  OpenFoodFactsTests
//
//  Created by Michael Charland on 2019-10-16.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import XCTest

class ProductTests: XCTestCase {

    func testMatchedLanguageCodeNoLanguagesSet() {
        let match = Product().matchedLanguageCode(codes: ["dog"])
        XCTAssertNil(match)
    }

    func testMatchedLanguageCodeMatch() {
        var product = Product()
        product.languageCodes = [String: Int]()
        product.languageCodes?["en"] = 5
        let match = product.matchedLanguageCode(codes: ["en"])
        XCTAssertEqual(match, "en")
    }

    func testMatchedLanguageCodeNoMatches() {
        var product = Product()
        product.languageCodes = [String: Int]()
        product.languageCodes?["en"] = 5
        let match = product.matchedLanguageCode(codes: ["jp"])
        XCTAssertNil(match)
    }
}
