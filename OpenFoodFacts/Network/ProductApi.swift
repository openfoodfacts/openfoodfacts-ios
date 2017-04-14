//
//  ProductApi.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol ProductApi {
    associatedtype Data
    
    func getProducts(byName name: String, page: Int, onSuccess: @escaping (Data) -> Void)
}

struct ProductService: ProductApi {
    
    fileprivate let endpoint = "https://ssl-api.openfoodfacts.org"
    
    func getProducts(byName name: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void) {
        print("Getting products for: \(name)")
        let url = endpoint + "/cgi/search.pl?search_terms=\(encodeParameters(name))&search_simple=1&action=process&json=1&page=\(page)"
        
        print("URL: \(url)")
        
        Alamofire.request(url).responseObject { (response: DataResponse<ProductsResponse>) in
            switch response.result {
            case .success(let productResponse):
                print("Got \(productResponse.count ?? 0) products ")
                onSuccess(productResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func encodeParameters(_ parameters: String) -> String {
        if let encodedParameters = parameters.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return encodedParameters
        } else {
            print("Could not add percentage encoding to: \(parameters)")
            return parameters.lowercased()
        }
    }
}
