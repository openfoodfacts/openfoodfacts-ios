//
//  ProductServiceMock.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
@testable import OpenFoodFacts
import ObjectMapper

class ProductServiceMock: ProductApi {

    // Common
    var product: Product?
    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)

    // getProducts
    var query: String?
    var page: Int?
    var getProductsCalled = false

    // getProduct
    var barcode: String?
    var productByBarcodeCount = 0
    var productByBarcodeScanning: Bool?

    // postImage
    var productImage: ProductImage?
    var postImageCount = 0

    // postProduct
    var postProductCalled = false

    // login
    var loginCalled = false
    var loginUsername: String?
    var loginPassword: String?

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        self.query = query
        self.page = page
        getProductsCalled = true
    }

    func getProduct(byBarcode barcode: String, isScanning: Bool, isSummary: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void) {
        let successfulBarcode = ["1", "2", "4"]

        self.barcode = barcode
        productByBarcodeCount += 1
        productByBarcodeScanning = isScanning

        if successfulBarcode.contains(barcode) {
            onSuccess(product)
        } else {
            onError(error)
        }
    }

    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.productImage = productImage
        postImageCount += 1

        let notConnectedErrorBarcodes = ["2", "4"]

        if notConnectedErrorBarcodes.contains(productImage.barcode) {
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            onError(error)
        } else if productImage.barcode == "3" {
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)
            onError(error)
        } else {
            onSuccess()
        }
    }

    func postProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.postProduct(product, rawParameters: nil, onSuccess: onSuccess, onError: onError)
    }

    func postProduct(_ product: Product, rawParameters: [String: Any]?, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.product = product
        postProductCalled = true

        if product.barcode == "2" {
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            onError(error)
        } else if product.barcode == "3" {
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)
            onError(error)
        } else {
            onSuccess()
        }
    }

    func getIngredientsOCR(forBarcode: String, productLanguageCode: String, onDone: @escaping (String?, Error?) -> Void) {
    }

    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        loginCalled = true
        loginUsername = username
        loginPassword = password
    }
}
