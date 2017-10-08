//
//  PictureViewModel.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

struct PictureViewModel {
    let imageType: ImageType
    let text: String?
    var image: UIImage?
    let uploadedPictureText: String?
}

extension PictureViewModel {
    init(imageType: ImageType) {
        var text = "\(NSLocalizedString("product.images.take-picture", comment: "")) "
        var uploadedPictureText: String?
        switch imageType {
        case .front:
            text += NSLocalizedString("product.images.front", comment: "")
            uploadedPictureText = "\(NSLocalizedString("product.images.product", comment: "")) \(NSLocalizedString("product.images.front", comment: "")) \(NSLocalizedString("product.images.picture", comment: ""))"
        case .ingredients:
            text += NSLocalizedString("product.images.ingredients", comment: "")
            uploadedPictureText = "\(NSLocalizedString("product.images.product", comment: "")) \(NSLocalizedString("product.images.ingredients", comment: "")) \(NSLocalizedString("product.images.picture", comment: ""))"
        case .nutrition:
            text += NSLocalizedString("product.images.nutrition", comment: "")
            uploadedPictureText = "\(NSLocalizedString("product.images.product", comment: "")) \(NSLocalizedString("product.images.nutrition", comment: "")) \(NSLocalizedString("product.images.picture", comment: ""))"
        }

        self.init(imageType: imageType, text: text, image: nil, uploadedPictureText: uploadedPictureText)
    }
}
