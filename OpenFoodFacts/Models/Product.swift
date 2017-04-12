//
//  Product.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

struct Product {
    var photo: UIImage?
    let name: String
    let brand: String
    let quantity: String
    
    init(name: String, brand: String, quantity: String) {
        self.name = name
        self.brand = brand
        self.quantity = quantity
    }
}
