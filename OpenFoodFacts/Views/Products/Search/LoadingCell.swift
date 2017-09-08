//
//  LoadingCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        if let activityIndicator = activityIndicator {
            activityIndicator.startAnimating()
        }
    }
}
