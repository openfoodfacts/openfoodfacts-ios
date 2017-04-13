//
//  Product.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ObjectMapper

class Product: Mappable {
    var photo: UIImage?
    var name: String?
    var brand: String?
    var quantity: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        name <- map[OFFJson.ProductNameKey]
        brand <- map[OFFJson.BrandsKey]
        quantity <- map[OFFJson.QuantityKey]
    }
}
