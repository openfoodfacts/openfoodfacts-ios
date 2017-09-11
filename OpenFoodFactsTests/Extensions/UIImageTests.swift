//
//  UIImageTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 11/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

// swiftlint:disable force_try
class UIImageTests: XCTestCase {
    func testRotateRightShouldRotateImageRightWhenInitialOrientationIsUp() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .up)
        XCTAssertEqual(UIImageOrientation.right, image.rotateRight()?.imageOrientation)
    }

    func testRotateRightShouldRotateImageDownWhenInitialOrientationIsRight() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .right)
        XCTAssertEqual(UIImageOrientation.down, image.rotateRight()?.imageOrientation)
    }

    func testRotateRightShouldRotateImageLeftWhenInitialOrientationIsDown() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .down)
        XCTAssertEqual(UIImageOrientation.left, image.rotateRight()?.imageOrientation)
    }

    func testRotateRightShouldRotateImageUpWhenInitialOrientationIsLeft() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .left)
        XCTAssertEqual(UIImageOrientation.up, image.rotateRight()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageLeftWhenInitialOrientationIsUp() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .up)
        XCTAssertEqual(UIImageOrientation.left, image.rotateLeft()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageDownWhenInitialOrientationIsLeft() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .left)
        XCTAssertEqual(UIImageOrientation.down, image.rotateLeft()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageRightWhenInitialOrientationIsDown() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .down)
        XCTAssertEqual(UIImageOrientation.right, image.rotateLeft()?.imageOrientation)
    }

    func testRotateLeftShouldRotateImageUpWhenInitialOrientationIsLeft() {
        let bundle = Bundle(for: type(of: self))
        let data = try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
        let testImage = UIImage(data: data)!
        let image = UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: .right)
        XCTAssertEqual(UIImageOrientation.up, image.rotateLeft()?.imageOrientation)
    }
}
