//
//  UIImage.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 28/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

extension UIImage {
    func rotateRight() -> UIImage? {
        var orientation = UIImage.Orientation.up
        switch self.imageOrientation {
        case .up:
            orientation = UIImage.Orientation.right
        case .right:
            orientation = UIImage.Orientation.down
        case .down:
            orientation = UIImage.Orientation.left
        case .left:
            orientation = UIImage.Orientation.up
        default:
            break
        }

        return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: orientation)
    }

    func rotateLeft() -> UIImage? {
        var orientation = UIImage.Orientation.up
        switch self.imageOrientation {
        case .up:
            orientation = UIImage.Orientation.left
        case .left:
            orientation = UIImage.Orientation.down
        case .down:
            orientation = UIImage.Orientation.right
        case .right:
            orientation = UIImage.Orientation.up
        default:
            break
        }

        return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: orientation)
    }
}
