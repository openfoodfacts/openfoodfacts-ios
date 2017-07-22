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
import Crashlytics

protocol ProductApi {
    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void)

    func getProduct(byBarcode barcode: String, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void)
}

struct ProductService: ProductApi {
    fileprivate let endpoint = "https://ssl-api.openfoodfacts.org"

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        var query = query
        var url = endpoint
        var searchType = "by_product"
        if query.isNumber() {
            query = buildBarcodeQueryParameter(query)
            url += "/code/\(query).json"
            searchType = "by_barcode"
            Crashlytics.sharedInstance().setObjectValue(query, forKey: "product_search_barcode")
        } else {
            url += "/cgi/search.pl?search_terms=\(encodeParameters(query))&search_simple=1&action=process&json=1&page=\(page)"
            Crashlytics.sharedInstance().setObjectValue(query, forKey: "product_search_name")
        }

        Crashlytics.sharedInstance().setObjectValue(searchType, forKey: "product_search_type")
        Crashlytics.sharedInstance().setObjectValue(page, forKey: "product_search_page")
        print("URL: \(url)")
        Answers.logSearch(withQuery: query, customAttributes: ["file": String(describing: ProductService.self), "search_type": searchType])

        Alamofire.request(url).responseObject { (response: DataResponse<ProductsResponse>) in
            switch response.result {
            case .success(let productResponse):
                print("Got \(productResponse.count) products ")
                productResponse.query = query
                onSuccess(productResponse)
            case .failure(let error):
                onError(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    func getProduct(byBarcode barcode: String, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        let url = endpoint + "/api/v0/product/\(barcode).json"

        Crashlytics.sharedInstance().setObjectValue(barcode, forKey: "product_search_barcode")
        Crashlytics.sharedInstance().setObjectValue("by_barcode", forKey: "product_search_type")
        print("URL: \(url)")

        Alamofire.request(url).responseObject { (response: DataResponse<ProductsResponse>) in
            switch response.result {
            case .success(let productResponse):
                onSuccess(productResponse)
            case .failure(let error):
                onError(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    fileprivate func encodeParameters(_ parameters: String) -> String {
        if let encodedParameters = parameters.lowercased().addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            return encodedParameters
        } else {
            print("Could not add percentage encoding to: \(parameters)")
            return parameters.lowercased()
        }
    }

    fileprivate func buildBarcodeQueryParameter(_ barcode: String) -> String {
        var ean13Barcode = barcode

        while ean13Barcode.characters.count < 13 {
            ean13Barcode += "x"
        }
        
        return ean13Barcode
    }
}
