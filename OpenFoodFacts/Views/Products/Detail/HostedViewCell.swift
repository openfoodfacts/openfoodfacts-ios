//
//  HostedViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class HostedViewCell: ProductDetailBaseCell {
    override class var estimatedHeight: CGFloat { return 150 }

    weak var hostedView: UIView! {
        didSet {
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(hostedView)
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[hostedView]-10-|", options: [], metrics: nil, views: ["hostedView": hostedView]))
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[hostedView]-10-|", options: [], metrics: nil, views: ["hostedView": hostedView]))
        }
    }
}
