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
    var name: String?
    var brands: String?
    var quantity: String?
    var imageUrl: String?
    var frontImageUrl: String?
    var barcode: String?
    var packaging: String?
    var categories: String?
    var nutriscore: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        name <- map[OFFJson.ProductNameKey]
        brands <- map[OFFJson.BrandsKey]
        quantity <- map[OFFJson.QuantityKey]
        frontImageUrl <- map[OFFJson.ImageFrontUrlKey]
        imageUrl <- map[OFFJson.ImageUrlKey]
        barcode <- map[OFFJson.CodeKey]
        packaging <- map[OFFJson.PackagingKey]
        categories <- map[OFFJson.CategoriesKey]
        nutriscore <- map[OFFJson.NutritionGradesKey]
    }
}
