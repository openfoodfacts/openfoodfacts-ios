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
        var text = "\("product.images.take-picture".localized) "
        var uploadedPictureText: String?
        switch imageType {
        case .front:
            text += "product.images.front".localized
            uploadedPictureText = "\("product.images.product".localized) \("product.images.front".localized) \("product.images.picture".localized)"
        case .ingredients:
            text += "product.images.ingredients".localized
            uploadedPictureText = "\("product.images.product".localized) \("product.images.ingredients".localized) \("product.images.picture".localized)"
        case .nutrition:
            text += "product.images.nutrition".localized
            uploadedPictureText = "\("product.images.product".localized) \("product.images.nutrition".localized) \("product.images.picture".localized)"
        }

        self.init(imageType: imageType, text: text, image: nil, uploadedPictureText: uploadedPictureText)
    }
}
