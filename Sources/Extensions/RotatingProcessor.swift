//
//  NormalizingProcessor.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 29/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

struct RotatingProcessor: ImageProcessor {
    // Rotate image

    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
        switch item {
        case .image(let image):
            switch image.imageOrientation {
            case .right:
                return image.rotateLeft()
            case .left:
                return image.rotateRight()
            default:
                return image
            }
        case .data:
            return nil
            // return (DefaultImageProcessor() >> self).process(item: item, options: options)
        }

    }
    let identifier = "org.openfoodfacts.orientation"

}
