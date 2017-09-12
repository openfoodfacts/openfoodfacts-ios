//
//  UIStackViewTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

class UIStackViewTests: XCTestCase {
    func testRemoveAllViews() {
        let stackView = UIStackView()
        stackView.addArrangedSubview(UIView())
        XCTAssertEqual(1, stackView.subviews.count)
        stackView.removeAllViews()
        XCTAssertEqual(0, stackView.subviews.count)
    }
}
