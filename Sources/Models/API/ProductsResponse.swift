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
    var query = ""
    var totalProducts = 0
    var page = "0"
    var pageSize = "0"
    var products = [Product]()
    var product: Product?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        totalProducts <- map[OFFJson.CountKey]
        page <- map[OFFJson.PageKey]
        pageSize <- map[OFFJson.PageSizeKey]
        products <- map[OFFJson.ProductsKey]
        product <- map[OFFJson.ProductKey]
    }
}
