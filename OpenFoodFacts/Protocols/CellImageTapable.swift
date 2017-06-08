//
//  CellImageFullScreenable.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 08/06/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

/// Protocol for UITableViewCells with an image that can be tapped to display fullscreen
protocol CellImageTapable: class {
    
    /// Image tap action handler
    ///
    /// - Parameters:
    ///   - image: Image that was tapped
    ///   - sender: Object that displays the image
    func didTap(image: UIImage?, sender: UITableViewCell)
}
