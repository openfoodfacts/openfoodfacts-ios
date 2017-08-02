//
//  SummaryHeaderCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SummaryHeaderCell: ProductDetailBaseCell {
    override class var estimatedHeight: CGFloat { return 188 }

    override func configure(with formRow: FormRow) {
        log.debug("Called, yay")
    }
}
