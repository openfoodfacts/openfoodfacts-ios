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
    func postImage(_ productImage: ProductImage, barcode: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func postProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
}

struct Endpoint {
    static let get = Bundle.main.infoDictionary?["GET_ENDPOINT"] as! String // swiftlint:disable:this force_cast
    static let post = Bundle.main.infoDictionary?["POST_ENDPOINT"] as! String // swiftlint:disable:this force_cast
}

class ProductService: ProductApi {
    private var lastGetProductsRequest: DataRequest?

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        lastGetProductsRequest?.cancel()

        var query = query
        var url = Endpoint.get
        var searchType: String
        if query.isNumber() {
            query = buildBarcodeQueryParameter(query)
            url += "/code/\(query).json"
            searchType = "by_barcode"
            Crashlytics.sharedInstance().setObjectValue(query, forKey: "product_search_barcode")
        } else {
            url += "/cgi/search.pl?search_terms=\(encodeParameters(query))&search_simple=1&action=process&json=1&page=\(page)"
            searchType = "by_product"
            Crashlytics.sharedInstance().setObjectValue(query, forKey: "product_search_name")
        }

        Crashlytics.sharedInstance().setObjectValue(searchType, forKey: "product_search_type")
        Crashlytics.sharedInstance().setObjectValue(page, forKey: "product_search_page")
        Answers.logSearch(withQuery: query, customAttributes: ["file": String(describing: ProductService.self), "search_type": searchType])

        let request = Alamofire.SessionManager.default.request(url)
        log.debug(request.debugDescription)
        request.responseObject { (response: DataResponse<ProductsResponse>) in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let productsResponse):
                log.debug("Got \(productsResponse.products.count) products ")
                productsResponse.query = query
                onSuccess(productsResponse)
            case .failure(let error):
                Crashlytics.sharedInstance().recordError(error)
                onError(error)
            }
        }

        self.lastGetProductsRequest = request
    }

    func getProduct(byBarcode barcode: String, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        var url: String

        // In debug mode we post products to the test environment (.net), so we use the post endpoint to get a product by barcode (when scanning it) 
        // so we get the product as a result for this get
        #if DEBUG
            url = Endpoint.post
        #else
            url = Endpoint.get
        #endif

        url += "/api/v0/product/\(barcode).json"

        Crashlytics.sharedInstance().setObjectValue(barcode, forKey: "product_search_barcode")
        Crashlytics.sharedInstance().setObjectValue("by_barcode", forKey: "product_search_type")

        let request: DataRequest = Alamofire.request(url)
        log.debug(request.debugDescription)
        request.authenticate(user: "off", password: "off")
            .responseObject { (response: DataResponse<ProductsResponse>) in
                log.debug(response.debugDescription)
                switch response.result {
                case .success(let productResponse):
                    onSuccess(productResponse)
                case .failure(let error):
                    Crashlytics.sharedInstance().recordError(error)
                    onError(error)
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
    func postImage(_ productImage: ProductImage, barcode: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        guard let fileURL = getImageUrl(productImage) else { return }

        if let barcode = barcode.data(using: .utf8) {
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(barcode, withName: "code")
                    multipartFormData.append(fileURL, withName: "imgupload_\(productImage.type.rawValue)")
                    multipartFormData.append(productImage.type.rawValue.data(using: .utf8)!, withName: "imagefield")
            },
                to: Endpoint.post + "/cgi/product_image_upload.pl",
                headers: ["Content-Disposition": "form-data; name=\"imgupload_\(productImage.type.rawValue)\"; filename=\"\(productImage.fileName)\""],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        log.debug(upload.debugDescription)
                        upload
                            .authenticate(user: "off", password: "off")
                            .responseJSON { response in
                                log.debug(response.debugDescription)
                                switch response.result {
                                case .success(let responseBody):
                                    if let json = responseBody as? [String: Any], let status = json["status"] as? String, "status ok" == status {
                                        onSuccess()
                                    } else {
                                        let error = NSError(domain: "ProductServiceErrorDomain", code: 1, userInfo: [
                                            "imageType": productImage.type.rawValue,
                                            "fileName": productImage.fileName,
                                            "fileURL": fileURL
                                            ])
                                        Crashlytics.sharedInstance().recordError(error)
                                        onError(error)
                                    }
                                case .failure(let error):
                                    Crashlytics.sharedInstance().recordError(error)
                                    onError(error)
                                }
                        }
                    case .failure(let encodingError):
                        Crashlytics.sharedInstance().recordError(encodingError)
                        onError(encodingError)
                    }
            })
        }
    }

    fileprivate func getImageUrl(_ productImage: ProductImage) -> URL? {
        do {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let filePath = "\(paths[0])/\(productImage.fileName)"
            let fileURL = URL(fileURLWithPath: filePath)
            if let image = productImage.image, let imageRepresentation = UIImageJPEGRepresentation(image, 0.1) {
                try imageRepresentation.write(to: fileURL)
                return fileURL
            }
            let error = NSError(domain: "ProductServiceErrorDomain", code: 1, userInfo: [
                "imageType": productImage.type.rawValue,
                "fileName": productImage.fileName,
                "isImageNil": productImage.image == nil,
                "message": "Unable to get UIImageJPEGRepresentation"
                ])
            Crashlytics.sharedInstance().recordError(error)
            return nil
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
            return nil
        }
    }

    func postProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        let request = Alamofire.request("\(Endpoint.post)/cgi/product_jqm2.pl", method: .post, parameters: product.toJSON(), encoding: URLEncoding.default)
        log.debug(request.debugDescription)
        request.authenticate(user: "off", password: "off")
            .responseJSON(completionHandler: { response in
                log.debug(response.debugDescription)
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [String: Any], let status = json["status_verbose"] as? String, "fields saved" == status {
                        onSuccess()
                    } else {
                        let error = NSError(domain: "ProductServiceErrorDomain", code: 1, userInfo: [
                            "product": product.toJSONString() ?? "{\"error\": \"Could convert product to JSON\"}"
                            ])
                        log.error(error)
                        Crashlytics.sharedInstance().recordError(error)
                        onError(error)
                    }
                case .failure(let error):
                    log.error(error)
                    Crashlytics.sharedInstance().recordError(error)
                    onError(error)
                }
            })
    }
}
