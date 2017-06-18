//
//  ConfigurableUITableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class ConfigurableUITableViewCell<T>: UITableViewCell {
    weak var delegate: CellImageTapable?
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint?
    
    func configure(with: T, completionHandler: (() -> Void)? = nil) {
        // Do nothing, expect implementation in subclasses
    }
    
    /// Check if the cell has enough information to be displayed
    ///
    /// - Parameter _: Object with the information to display
    /// - Returns: true when the object has enough information to display the cell
    class func hasMinimumInformation(_: T) -> Bool {
        return true
    }
}
