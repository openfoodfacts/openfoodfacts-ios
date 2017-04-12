//
//  ProductTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    func configure(withProduct product: Product) {
        // TODO photo.image = product.photo
        name.text = product.name
        brand.text = product.brand
        quantity.text = product.quantity
    }
}
