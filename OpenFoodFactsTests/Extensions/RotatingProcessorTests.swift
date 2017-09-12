//
//  RotatingProcessorTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Kingfisher

class RotatingProcessorTests: XCTestCase {
    func testProcessShouldRotateImageLeftWhenInitialOrientationIsRight() {
        let rotatinProcessor = RotatingProcessor()
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .right)
        let item = ImageProcessItem.image(image)
        let result = rotatinProcessor.process(item: item, options: [])
        XCTAssertEqual(UIImageOrientation.up, result?.imageOrientation)
    }

    func testProcessShouldRotateImageRightWhenInitialOrientationIsLeft() {
        let rotatinProcessor = RotatingProcessor()
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .left)
        let item = ImageProcessItem.image(image)
        let result = rotatinProcessor.process(item: item, options: [])
        XCTAssertEqual(UIImageOrientation.up, result?.imageOrientation)
    }

    func testProcessShouldNotRotateImageRightWhenInitialOrientationIsNotRightOrLeft() {
        let rotatinProcessor = RotatingProcessor()
        let image = TestHelper.sharedInstance.getTestImageWith(orientation: .up)
        let item = ImageProcessItem.image(image)
        let result = rotatinProcessor.process(item: item, options: [])
        XCTAssertEqual(UIImageOrientation.up, result?.imageOrientation)
    }

    func testProcessShouldUseDefaultProcessorWhenItemIsNotData() {
        let rotatinProcessor = RotatingProcessor()
        let data = TestHelper.sharedInstance.geTestImageData()
        let item = ImageProcessItem.data(data)
        let result = rotatinProcessor.process(item: item, options: [])
        XCTAssertNotNil(result)
    }
}
