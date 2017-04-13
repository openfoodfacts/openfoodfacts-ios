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
    var query: String?
    var count: Int?
    var page: String?
    var products: [Product]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map[OFFJson.CountKey]
        page <- map[OFFJson.PageKey]
        products <- map[OFFJson.ProductsKey]
    }
}
