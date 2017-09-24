//
//  TestHelper.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Nimble

// swiftlint:disable force_try
class TestHelper {
    static let sharedInstance = TestHelper()

    func geTestImageData() -> Data {
        let bundle = Bundle(for: type(of: self))
        return try! NSData(contentsOfFile: bundle.path(forResource: "test_image", ofType: "jpg")!) as Data
    }

    func getTestImage() -> UIImage {
        let data = geTestImageData()
        return UIImage(data: data)!
    }

    func getTestImageWith(orientation: UIImageOrientation) -> UIImage {
        let testImage = getTestImage()
        return UIImage(cgImage: testImage.cgImage!, scale: 1.0, orientation: orientation)
    }

    func getJson(_ fileName: String) -> [String: Any] {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else { fail("Failed to get json file: \(fileName)"); return [:] }
        guard let data = try? Data(contentsOf: url) else { fail("Failed to read json file"); return [:] }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { fail("Failed to parse json"); return [:] }
        guard let json = jsonObject as? [String: Any] else { fail("Failed to cast json"); return [:] }
        return json
    }
}
