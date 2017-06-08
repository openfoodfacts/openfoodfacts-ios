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
    
    func configure(with: T, completionHandler: (() -> Void)? = nil) {
        // Do nothing, expect implementation in subclasses
    }
}
