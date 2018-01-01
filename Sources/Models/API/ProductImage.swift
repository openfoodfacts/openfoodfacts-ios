//
//  ProductImage.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 26/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Crashlytics

enum ImageType: String {
    case front
    case ingredients
    case nutrition
}

struct ProductImage {
    let barcode: String
    let image: UIImage
    let fileName: String
    let type: ImageType

    /// Save image locally.
    /// Init will fail when the image could not be saved.
    ///
    /// - Parameters:
    ///   - barcode: product's barcode
    ///   - image: image to save
    ///   - type: type of product image
    init?(barcode: String, image: UIImage, type: ImageType) {
        self.barcode = barcode
        self.image = image
        self.fileName = "\(UUID().uuidString).jpg"
        self.type = type

        guard saveImage(image) != nil else { return nil }
    }

    /// Load an image stored locally.
    /// Init will fail when the image could not be loaded.
    ///
    /// - Parameters:
    ///   - barcode: product's barcode
    ///   - fileName: Image's file name. It should be created as follows: "\(UUID().uuidString).jpg". It is done internally, using the other initializer.
    ///   - type: type of product image
    init?(barcode: String, fileName: String, type: ImageType) {
        self.barcode = barcode
        self.fileName = fileName
        self.type = type

        guard let image = ProductImage.loadImage(fileName) else { return nil }
        self.image = image
    }

    private func saveImage(_ image: UIImage) -> String? {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            let error = NSError(domain: Errors.domain, code: Errors.codes.generic.rawValue, userInfo: [
                "imageType": type.rawValue,
                "fileName": fileName,
                "message": "Unable to get UIImageJPEGRepresentation"
                ])
            Crashlytics.sharedInstance().recordError(error)
            return nil
        }

        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = documentsURL.appendingPathComponent(fileName)
            try data.write(to: imageURL)
            return fileName
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
            return nil
        }
    }

    private static func loadImage(_ imageName: String) -> UIImage? {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = documentsURL.appendingPathComponent(imageName)
            let imageData = try Data(contentsOf: imageURL)
            return UIImage(data: imageData)
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
            return nil
        }
    }

    func deleteImage() {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = documentsURL.appendingPathComponent(fileName)
            try FileManager.default.removeItem(at: imageURL)
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
        }
    }
}
