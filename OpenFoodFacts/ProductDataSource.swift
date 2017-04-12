//
//  ProductDataSource.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import Alamofire

class ProductDataSource {
    
    let endpoint = "https://ssl-api.openfoodfacts.org"
    
    func getProducts(byName name: String) {
        Alamofire.request(endpoint + "/cgi/search.pl?search_terms=\(encodeStringAsParameter(name))&search_simple=1&action=process&json=1").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    fileprivate func encodeStringAsParameter(_ string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "+")
    }
}
