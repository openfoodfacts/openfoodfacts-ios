//
//  ProductsResponse.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 13/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductsResponse: Mappable {
    var count: Int?
    var products: [Product]?
    var page: String?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        products <- map["products"]
    }
}
