//
//  NutritionLevelView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 08/06/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionLevelView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var level: UILabel!

    func configure(image: UIImage?, value: String, label: String, level: String) {
        self.imageView.image = image
        self.value.text = value
        self.label.text = label
        self.level.text = level
    }
}
