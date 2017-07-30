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

    weak var hostedView: UIView! {
        didSet {
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(hostedView)
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[hostedView]-10-|", options: [], metrics: nil, views: ["hostedView": hostedView]))
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[hostedView]-10-|", options: [], metrics: nil, views: ["hostedView": hostedView]))
        }
    }

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
