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
        var orientation = UIImageOrientation.up
        switch self.imageOrientation {
        case .up:
            orientation = UIImageOrientation.right
        case .right:
            orientation = UIImageOrientation.down
        case .down:
            orientation = UIImageOrientation.left
        case .left:
            orientation = UIImageOrientation.up
        default:
            break
        }

        return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: orientation)
    }

    func rotateLeft() -> UIImage? {
        var orientation = UIImageOrientation.up
        switch self.imageOrientation {
        case .up:
            orientation = UIImageOrientation.left
        case .left:
            orientation = UIImageOrientation.down
        case .down:
            orientation = UIImageOrientation.right
        case .right:
            orientation = UIImageOrientation.up
        default:
            break
        }

        return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: orientation)
    }
}
