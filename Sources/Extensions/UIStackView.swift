//
//  UIStackView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 08/06/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

extension UIStackView {
    /// Remove all views in the stack view
    func removeAllViews() {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
