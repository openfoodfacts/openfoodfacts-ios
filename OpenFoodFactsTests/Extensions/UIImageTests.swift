//
//  UIImageTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 11/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

class UIImageTests: XCTestCase {
    func testRotateRightShouldRotateImageRightWhenInitialOrientationIsUp() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .up)
        XCTAssertEqual(UIImageOrientation.right, image.rotateRight()?.imageOrientation)
    }

    func testRotateRightShouldRotateImageDownWhenInitialOrientationIsRight() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .right)
        XCTAssertEqual(UIImageOrientation.down, image.rotateRight()?.imageOrientation)
    }

    func testRotateRightShouldRotateImageLeftWhenInitialOrientationIsDown() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .down)
        XCTAssertEqual(UIImageOrientation.left, image.rotateRight()?.imageOrientation)
    }

    func testRotateRightShouldRotateImageUpWhenInitialOrientationIsLeft() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .left)
        XCTAssertEqual(UIImageOrientation.up, image.rotateRight()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageLeftWhenInitialOrientationIsUp() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .up)
        XCTAssertEqual(UIImageOrientation.left, image.rotateLeft()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageDownWhenInitialOrientationIsLeft() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .left)
        XCTAssertEqual(UIImageOrientation.down, image.rotateLeft()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageRightWhenInitialOrientationIsDown() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .down)
        XCTAssertEqual(UIImageOrientation.right, image.rotateLeft()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageUpWhenInitialOrientationIsLeft() {
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .right)
        XCTAssertEqual(UIImageOrientation.up, image.rotateLeft()?.imageOrientation)
    }
}
