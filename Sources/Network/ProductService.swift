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
    func getProduct(byBarcode barcode: String, isScanning: Bool, isSummary: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void)
    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func postProduct(_ product: Product, rawParameters: [String: Any]?, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func getIngredientsOCR(forBarcode: String, productLanguageCode: String, onDone: @escaping (String?, Error?) -> Void)
}

struct Endpoint {
    static let get = Bundle.main.infoDictionary?["GET_ENDPOINT"] as! String // swiftlint:disable:this force_cast
    static let post = Bundle.main.infoDictionary?["POST_ENDPOINT"] as! String // swiftlint:disable:this force_cast
    static let login = Bundle.main.infoDictionary?["LOGIN_ENDPOINT"] as! String // swiftlint:disable:this force_cast
}

struct Params {
    static let code = "code"
    static let imagefield = "imagefield"
    static let userId = "user_id"
    static let password = "password"
    static let submit = ".submit"
}

class ProductService: ProductApi {
    private var lastGetProductsRequest: DataRequest?

    private let utilityQueue = DispatchQueue.global(qos: .utility)

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
        request.responseObject(queue: utilityQueue) { (response: DataResponse<ProductsResponse>) in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let productsResponse):
                log.debug("Got \(productsResponse.products.count) products ")
                productsResponse.query = query
                onSuccess(productsResponse)
            case .failure(let error as NSError):
                Crashlytics.sharedInstance().recordError(error)
                onError(error)
            }
        }

        self.lastGetProductsRequest = request
    }

    let summaryFields: [String] = [
        OFFJson.CodeKey,
        OFFJson.ImageFrontUrlKey,
        OFFJson.ImageFrontSmallUrlKey,
        OFFJson.ImageUrlKey,
        OFFJson.ImageSmallUrlKey,
        OFFJson.BrandsKey,
        OFFJson.ProductNameKey,
        OFFJson.QuantityKey,
        OFFJson.NutritionGradesKey,
        OFFJson.NovaGroupKey,
        OFFJson.EnvironmentImpactLevelTagsKey
    ]

    // swiftlint:disable:next line_length
    let allFields: String = "image_small_url,vitamins_tags,minerals_tags,amino_acids_tags,other_nutritional_substances_tags,image_front_url,image_ingredients_url,image_nutrition_url,url,code,traces_tags,ingredients_that_may_be_from_palm_oil_tags,additives_tags,allergens_hierarchy,manufacturing_places,nutriments,ingredients_from_palm_oil_tags,brands_tags,traces,categories_tags,ingredients_text,product_name,generic_name,ingredients_from_or_that_may_be_from_palm_oil_n,serving_size,allergens_tags,allergens,origins,stores,nutrition_grade_fr,nutrient_levels,countries,countries_tags,brands,packaging,labels_tags,labels_hierarchy,cities_tags,quantity,ingredients_from_palm_oil_n,image_url,link,emb_codes_tags,nutrition_grades,states_tags,creator,created_t,last_modified_t,last_modified_by,editors_tags,nova_group,nova_groups,lang,languages_codes,purchase_places,nutrition_data_per,no_nutrition_data,other_information,conservation_conditions,recycling_instructions_to_discard,recycling_instructions_to_recycle,warning,customer_service,environment_infocard,environment_impact_level_tags"

    func getProduct(byBarcode barcode: String, isScanning: Bool, isSummary: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void) {

        var url: String

        // In debug mode we post products to the test environment (.net), so we use the post endpoint to get a product by barcode (when scanning it) 
        // so we get the product as a result for this get
        #if DEBUG
            if isScanning {
                url = Endpoint.post
            } else {
                url = Endpoint.get
            }
        #else
            url = Endpoint.get
        #endif

        url += "/api/v0/product/\(barcode).json"

        Crashlytics.sharedInstance().setObjectValue(barcode, forKey: "product_search_barcode")
        Crashlytics.sharedInstance().setObjectValue("by_barcode", forKey: "product_search_type")

        /* aleene: disabled to get all fields, not only those specified
        if isSummary {
            // When we ask for a summary of the product, we specify to the server which fields we want (to make a smaller request). We would prefere to use the 'Parameter' normally used by Alamofire in this case, but this generates an url like
            // {{host}}/product.json?fields=product_name%2Cbrands
            // instead of
            // {{host}}/product.json?fields=product_name,brands
            // and it seems the server does not handle that, and does not return any field
            // so we just append our fields directly to the url

            url.append(contentsOf: "?fields=" + summaryFields.joined(separator: ","))
        } else {
            url.append(contentsOf: "?fields=" + allFields)
        }
 */

        let request: DataRequest = Alamofire.request(url)
        log.debug(request.debugDescription)

        #if DEBUG
            request.authenticate(user: "off", password: "off")
        #endif

        request.responseObject(queue: utilityQueue) { (response: DataResponse<ProductsResponse>) in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let productResponse):
                DispatchQueue.global(qos: .background).async {
                    onSuccess(productResponse.product)
                }
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

        while ean13Barcode.count < 13 {
            ean13Barcode += "x"
        }

        return ean13Barcode
    }
}

extension ProductService {
    // swiftlint:disable:next function_body_length
    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        guard let fileURL = getImageUrl(productImage) else { log.debug("Unable to get image url"); return }

        if let barcode = productImage.barcode.data(using: .utf8) {
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(barcode, withName: Params.code)
                    multipartFormData.append(fileURL, withName: "imgupload_\(productImage.type.rawValue)")
                    let lang = Bundle.main.preferredLocalizations.first ?? "en"
                    multipartFormData.append(("\(productImage.type.rawValue)_\(lang)").data(using: .utf8)!, withName: Params.imagefield)

                    if let credentials = CredentialsController.shared.getCredentials(),
                        let username = credentials.username.data(using: .utf8),
                        let password = credentials.password.data(using: .utf8) {
                        multipartFormData.append(username, withName: Params.userId)
                        multipartFormData.append(password, withName: Params.password)
                    }
            },
                to: Endpoint.post + "/cgi/product_image_upload.pl",
                headers: ["Content-Disposition": "form-data; name=\"imgupload_\(productImage.type.rawValue)\"; filename=\"\(productImage.fileName)\""],
                encodingCompletion: { encodingResult in
                    self.utilityQueue.async {
                        switch encodingResult {
                        case .success(let upload, _, _):
                            #if DEBUG
                                upload.authenticate(user: "off", password: "off")
                            #endif

                            log.debug(upload.debugDescription)
                            upload.responseJSON { response in
                                log.debug(response.debugDescription)
                                switch response.result {
                                case .success(let responseBody):
                                    if let json = responseBody as? [String: Any], let status = json["status"] as? String, "status ok" == status {
                                        onSuccess()
                                    } else {
                                        let error = NSError(domain: Errors.domain, code: Errors.codes.generic.rawValue, userInfo: [
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
                    }
            })
        }
    }

    fileprivate func getImageUrl(_ productImage: ProductImage) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath = "\(paths[0])/\(productImage.fileName)"
        return URL(fileURLWithPath: filePath)
    }

    func postProduct(_ product: Product, rawParameters: [String: Any]?, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        var params = product.toJSON()

        if let rawParameters = rawParameters {
            params.merge(rawParameters) { $1 }
        }

        if let credentials = CredentialsController.shared.getCredentials() {
            params[Params.userId] = credentials.username
            params[Params.password] = credentials.password
        }

        var appVersion = "unknown"
        var id = "unknown"

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            id = uuid
        }
        params["comment"] = "Contributed using: OFF app for iOS - v\(appVersion) - user id: \(id)"

        let request = Alamofire.request("\(Endpoint.post)/cgi/product_jqm2.pl", method: .post, parameters: params, encoding: URLEncoding.default)
        log.debug(request.debugDescription)

        request.responseJSON(queue: utilityQueue) { response in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let responseBody):
                if let json = responseBody as? [String: Any], let status = json["status_verbose"] as? String, "fields saved" == status {
                    onSuccess()
                } else {
                    let userInfo = ["product": product.toJSONString() ?? "{\"error\": \"Could convert product to JSON\"}"]
                    let error = NSError(domain: Errors.domain, code: Errors.codes.generic.rawValue, userInfo: userInfo)
                    log.error(error)
                    Crashlytics.sharedInstance().recordError(error)
                    onError(error)
                }
            case .failure(let error):
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
                onError(error)
            }
        }
    }

    func getIngredientsOCR(forBarcode: String, productLanguageCode: String, onDone: @escaping (String?, Error?) -> Void) {

        let params = [
            "process_image": "1",
            "ocr_engine": "google_cloud_vision",
            "code": forBarcode,
            "id": "ingredients_\(productLanguageCode)"
        ]

        let request = Alamofire.request("\(Endpoint.get)/cgi/ingredients.pl", method: .get, parameters: params, encoding: URLEncoding.default)

        request.responseJSON(queue: utilityQueue) { response in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let responseBody):
                if let json = responseBody as? [String: Any] {
                    onDone(json["ingredients_text_from_image"] as? String, nil)
                } else {
                    onDone(nil, nil)
                }
            case .failure(let error):
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
                onDone(nil, error)
            }
        }
    }
}

extension ProductService {
    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        let parameters = [Params.userId: username, Params.password: password, Params.submit: "Sign-in"]
        let request = Alamofire.request(Endpoint.login, method: .post, parameters: parameters)
        log.debug(request.debugDescription)
        request.responseString(queue: utilityQueue) { response in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let html):
                if !html.contains("Incorrect user name or password.") && !html.contains("See you soon!") {
                    CredentialsController.shared.saveCredentials(username: username, password: password)
                    onSuccess()
                } else {
                    let error = NSError(domain: Errors.domain, code: Errors.codes.wrongCredentials.rawValue)
                    log.error(error)
                    onError(error)
                }
            case .failure(let error as NSError):
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
                onError(error)
            }
        }
    }
}
