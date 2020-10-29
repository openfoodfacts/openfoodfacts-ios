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
import UIKit

protocol ProductApi {
    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void)
    func getProduct(byBarcode barcode: String, isScanning: Bool, isSummary: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void)
    func getLatestRobotoffQuestions(forBarcode barcode: String, onSuccess: @escaping ([RobotoffQuestion]) -> Void, onError: @escaping (Error) -> Void)
    func postRobotoffAnswer(forInsightId insightId: String, withAnnotation: Int, onDone: @escaping () -> Void)
    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func postProduct(_ product: Product, rawParameters: [String: Any]?, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func getIngredientsOCR(forBarcode: String, productLanguageCode: String, onDone: @escaping (String?, Error?) -> Void)
}

struct Endpoint {
    static let get = Bundle.main.infoDictionary?["GET_ENDPOINT"] as! String // swiftlint:disable:this force_cast
    static let post = Bundle.main.infoDictionary?["POST_ENDPOINT"] as! String // swiftlint:disable:this force_cast
    static let login = Bundle.main.infoDictionary?["LOGIN_ENDPOINT"] as! String // swiftlint:disable:this force_cast
    static let robotoff = Bundle.main.infoDictionary?["ROBOTOFF_ENDPOINT"] as! String // swiftlint:disable:this force_cast
}

struct Params {
    static let code = "code"
    static let imagefield = "imagefield"
    static let userId = "user_id"
    static let password = "password"
    static let submit = ".submit"
}

class ProductService: ProductApi {

    struct NotificationUserInfoKey {
        static let ImageUploadFractionDouble = "image-upload-fraction-double"
        static let ImageUploadBarcodeString = "image-upload-barcode-string"
        static let ImageUploadTypeString = "image-upload-imageType-string"
        static let ImageUploadLanguageString = "image-upload-language-string"
    }

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
            AnalyticsManager.log(query, forKey: "product_search_barcode")
        } else {
            url += "/cgi/search.pl?search_terms=\(encodeParameters(query))&search_simple=1&action=process&json=1&page=\(page)"
            url.append(contentsOf: "&fields=" + OFFJson.summaryFields.joined(separator: OFFJson.FieldsSeparator))
            searchType = "by_product"
            AnalyticsManager.log(query, forKey: "product_search_name")
        }

        AnalyticsManager.log(searchType, forKey: "product_search_type")
        AnalyticsManager.log("\(page)", forKey: "product_search_page")
        //Answers.logSearch(withQuery: query, customAttributes: ["file": String(describing: ProductService.self), "search_type": searchType])

        let request = Alamofire.SessionManager.default.request(url)
        // following getProduct api call's debug mode authentication values
        #if DEBUG
            request.authenticate(user: "off", password: "off")
        #endif
        log.debug(request.debugDescription)
        request.responseObject(queue: utilityQueue) { (response: DataResponse<ProductsResponse>) in
            log.debug(response.debugDescription)
            switch response.result {
            case .success(let productsResponse):
                log.debug("Got \(productsResponse.products.count) products ")
                productsResponse.query = query
                onSuccess(productsResponse)
            case .failure(let error as NSError):
                AnalyticsManager.record(error: error)
                onError(error)
            }
        }

        self.lastGetProductsRequest = request
    }

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

        AnalyticsManager.log(barcode, forKey: "product_search_barcode")
        AnalyticsManager.log("by_barcode", forKey: "product_search_type")

        // aleene: disabled to get all fields, not only those specified
         // we cannot use the summary or the list as the tags are product and language dependent.
        if isSummary {
            // When we ask for a summary of the product, we specify to the server which fields we want (to make a smaller request). We would prefere to use the 'Parameter' normally used by Alamofire in this case, but this generates an url like
            // {{host}}/product.json?fields=product_name%2Cbrands
            // instead of
            // {{host}}/product.json?fields=product_name,brands
            // and it seems the server does not handle that, and does not return any field
            // so we just append our fields directly to the url

            //var languageFields = [""]
            //for code in Locale.preferredLanguageCodes {
            //    languageFields.append(OFFJson.ProductNameKey + OFFJson.KeySeparator + code)
            //}
            //url.append(contentsOf: "?fields=" + summaryFields.joined(separator: OFFJson.FieldsSeparator) + OFFJson.FieldsSeparator + languageFields.joined(separator: OFFJson.FieldsSeparator))
            url.append(contentsOf: "?fields=" + OFFJson.summaryFields.joined(separator: OFFJson.FieldsSeparator))
        } else {
            let allFieldsWithAttributeGroups = OFFJson.allFields + [ProductAttributesJson.attributeGroupsLang()]
            url.append(contentsOf: "?fields=" + allFieldsWithAttributeGroups.joined(separator: OFFJson.FieldsSeparator) + OFFJson.languageCodes)
        }
 //

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
                    var product = productResponse.product
                    product?.productAttributes = productResponse.productAttributes
                    onSuccess(product)
                }
            case .failure(let error):
                AnalyticsManager.record(error: error)
                onError(error)
            }
        }
    }

    func getLatestRobotoffQuestions(forBarcode barcode: String, onSuccess: @escaping ([RobotoffQuestion]) -> Void, onError: @escaping (Error) -> Void) {
        let url = Endpoint.robotoff + "/api/v1/questions/\(barcode)?lang=\(Locale.interfaceLanguageCode)&count=6"
        Alamofire.request(url).responseObject { (response: DataResponse<RobotoffResponse>) in
            switch response.result {
            case .success(let robotoffResponse):
                onSuccess(robotoffResponse.questions.filter({ $0.type == "add-binary" }))
            case .failure(let error):
                AnalyticsManager.record(error: error)
                onError(error)
            }
        }
    }

    func postRobotoffAnswer(forInsightId insightId: String, withAnnotation: Int, onDone: @escaping () -> Void) {
        let url = Endpoint.robotoff + "/api/v1/insights/annotate"

        guard let credentials = CredentialsController.shared.getCredentials() else { return }

        let credentialData = "\(credentials.username):\(credentials.password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()

        Alamofire.request(url, method: .post, parameters: [
            "insight_id": insightId,
            "annotation": withAnnotation,
            "update": 1
        ], headers: ["Authorization": "Basic \(base64Credentials)"]).response { (response: DefaultDataResponse) in
            log.debug("Answer from post to robotoff: \(response)")
            onDone()
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
                    let lang = productImage.languageCode
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

                            // Post a notification on the image upload progress
                            upload.uploadProgress { progress in
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: .imageUploadProgress,
                                                                    object: nil,
                                                                    userInfo: [NotificationUserInfoKey.ImageUploadFractionDouble: progress.fractionCompleted,
                                                                               NotificationUserInfoKey.ImageUploadBarcodeString: productImage.barcode,
                                                                               NotificationUserInfoKey.ImageUploadTypeString: productImage.type.rawValue,
                                                                               NotificationUserInfoKey.ImageUploadLanguageString: productImage.languageCode ])
                                }
                            }

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
                                        AnalyticsManager.record(error: error)
                                        onError(error)
                                    }
                                case .failure(let error):
                                    AnalyticsManager.record(error: error)
                                    onError(error)
                                }
                            }
                        case .failure(let encodingError):
                            AnalyticsManager.record(error: encodingError)
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

        // handle translated fields
        if let lang = product.lang {
            if let productName = product.names[lang] {
                params["product_name"] = nil
                params["product_name_\(lang)"] = productName
            }
            if let productIngredients = product.ingredients[lang] {
                params["ingredients_text"] = nil
                params["ingredients_text_\(lang)"] = productIngredients
            }
        }

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
                    AnalyticsManager.record(error: error)
                    onError(error)
                }
            case .failure(let error):
                log.error(error)
                AnalyticsManager.record(error: error)
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
                AnalyticsManager.record(error: error)
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
                AnalyticsManager.record(error: error)
                onError(error)
            }
        }
    }
}
extension Notification.Name {
    static let imageUploadProgress = Notification.Name("image-upload-progress")
}
