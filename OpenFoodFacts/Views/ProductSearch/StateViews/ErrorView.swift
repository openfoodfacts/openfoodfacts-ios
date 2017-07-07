//
//  ErrorView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

fileprivate let textColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:0.78)

class ErrorView: StateView {
    override func setupView() {
        super.setupView()
        
        self.frame = super.frame
        
        let mainLabel = UILabel()
        mainLabel.text = NSLocalizedString("product-search.error-view.title", comment: "Error view title")
        mainLabel.textAlignment = .center
        mainLabel.textColor = textColor
        mainLabel.font = mainLabel.font.withSize(25)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.sizeToFit()
        
        let secondayLabel = UILabel()
        secondayLabel.text = NSLocalizedString("product-search.error-view.subtitle", comment: "Error view subtitle")
        secondayLabel.textAlignment = .center
        secondayLabel.textColor = textColor
        secondayLabel.font = mainLabel.font.withSize(18)
        secondayLabel.translatesAutoresizingMaskIntoConstraints = false
        secondayLabel.sizeToFit()
        
        let stack = UIStackView(frame: self.bounds)
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(mainLabel)
        stack.addArrangedSubview(secondayLabel)
        stack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let centerHorizontally = NSLayoutConstraint(item: stack, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerVertically = NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addSubview(stack)
        self.addConstraints([centerHorizontally, centerVertically])
    }
}
