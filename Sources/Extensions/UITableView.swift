//
//  UITableView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

extension UITableView {

    /// Last index path in the first section (section 0)
    var lastIndexPath: IndexPath {
        return IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0)
    }
}
