//
//  UITableViewCellTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 11/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

class UITableViewCellTests: XCTestCase {
    func testIdentifier() {
        XCTAssertEqual("UITableViewCell", UITableViewCell.identifier)
    }
}
