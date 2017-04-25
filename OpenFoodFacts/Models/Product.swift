//
//  Product.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ObjectMapper

struct Product: Mappable {
    var name: String?
    var brands: String?
    var quantity: String?
    var imageUrl: String?
    var frontImageUrl: String?
    var barcode: String?
    var packaging: String?
    var categories: String?
    var nutriscore: String?
    var manufacturingPlaces: String?
    var origins: String?
    var labels: String?
    var citiesTags: String?
    var stores: String?
    var countries: String?
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        name <- map[OFFJson.ProductNameKey]
        brands <- map[OFFJson.BrandsKey]
        quantity <- map[OFFJson.QuantityKey]
        frontImageUrl <- map[OFFJson.ImageFrontUrlKey]
        imageUrl <- map[OFFJson.ImageUrlKey]
        barcode <- map[OFFJson.CodeKey]
        packaging <- map[OFFJson.PackagingKey]
        categories <- map[OFFJson.CategoriesKey]
        nutriscore <- map[OFFJson.NutritionGradesKey]
        manufacturingPlaces <- map[OFFJson.ManufacturingPlacesKey]
        origins <- map[OFFJson.OriginsKey]
        labels <- map[OFFJson.LabelsKey]
        citiesTags <- map[OFFJson.CitiesTagsKey]
        stores <- map[OFFJson.StoresKey]
        countries <- map[OFFJson.CountriesKey]
    }
}
