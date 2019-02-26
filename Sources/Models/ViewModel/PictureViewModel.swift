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
    var isUploading: Bool = false
}

extension PictureViewModel {
    init(imageType: ImageType) {
        var text: String?
        var uploadedPictureText: String?
        switch imageType {
        case .front:
            text = "product.images.take-picture.front".localized
            uploadedPictureText = "product.images.took-picture.front".localized
        case .ingredients:
            text = "product.images.take-picture.ingredients".localized
            uploadedPictureText = "product.images.took-picture.ingredients".localized
        case .nutrition:
            text = "product.images.take-picture.nutrition".localized
            uploadedPictureText = "product.images.took-picture.nutrition".localized
        }

        self.init(imageType: imageType, text: text, image: nil, uploadedPictureText: uploadedPictureText, isUploading: false)
    }
}
