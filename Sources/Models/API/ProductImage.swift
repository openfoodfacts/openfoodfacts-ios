//
//  ProductImage.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 26/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

enum ImageType: String {
    case front
    case ingredients
    case nutrition
}

struct ProductImage {
    let barcode: String
    let image: UIImage
    let fileURL: URL?
    let fileName = "\(UUID().uuidString).jpg"
    let type: ImageType

    init(barcode: String, image: UIImage, type: ImageType) {
        self.barcode = barcode
        self.image = image
        self.fileURL = nil
        self.type = type
    }
}
