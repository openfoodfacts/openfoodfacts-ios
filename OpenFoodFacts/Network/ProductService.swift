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
import UIKit

protocol ProductApi {
    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void)

    func getProduct(byBarcode barcode: String, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void)

    func uploadImage(_ image: UIImage, barcode: String)
}

fileprivate let getEndpoint = "https://ssl-api.openfoodfacts.org"
fileprivate let postEndpoint = "https://world.openfoodfacts.net"

struct ProductService: ProductApi {
    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        var query = query
        var url = getEndpoint
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
        log.debug("URL: \(url)")
        Answers.logSearch(withQuery: query, customAttributes: ["file": String(describing: ProductService.self), "search_type": searchType])

        Alamofire.request(url).responseObject { (response: DataResponse<ProductsResponse>) in
            switch response.result {
            case .success(let productResponse):
                log.debug("Got \(productResponse.count) products ")
                productResponse.query = query
                onSuccess(productResponse)
            case .failure(let error):
                onError(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    func getProduct(byBarcode barcode: String, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        let url = getEndpoint + "/api/v0/product/\(barcode).json"

        Crashlytics.sharedInstance().setObjectValue(barcode, forKey: "product_search_barcode")
        Crashlytics.sharedInstance().setObjectValue("by_barcode", forKey: "product_search_type")
        log.debug("URL: \(url)")

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
            log.debug("Could not add percentage encoding to: \(parameters)")
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

extension ProductService {
    func uploadImage(_ image: UIImage, barcode: String) {
        if let imageRepresentation = UIImageJPEGRepresentation(image, 1.0), let barcode = barcode.data(using: .utf8) {
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(barcode, withName: "code")
                    multipartFormData.append(imageRepresentation, withName: "imagefield")
            },
                to: postEndpoint + "/cgi/product_image_upload.pl",
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload
                        .authenticate(user: "off", password: "off")
                        .responseJSON { response in
                            debugPrint(response)
                        }
                    case .failure(let encodingError):
                        debugPrint(encodingError)
                    }
            })
        }
    }
}
