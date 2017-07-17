//
//  EmptyView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class EmptyView: StateView {
    override func setupView() {
        super.setupView()

        self.frame = super.frame

        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = NSLocalizedString("product-search.no-results", comment: "No products where found for current search")
        emptyLabel.textAlignment = .center
        emptyLabel.sizeToFit()

        let centerHorizontally = NSLayoutConstraint(item: emptyLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerVertically = NSLayoutConstraint(item: emptyLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

        self.addSubview(emptyLabel)
        self.addConstraints([centerHorizontally, centerVertically])
    }
}
