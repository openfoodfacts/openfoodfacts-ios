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
    var dataManager: DataManagerProtocol!

    var query: String?
    var page: Int?
    var productsResponse: ProductsResponse!
    let error = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil)
    let cancelledError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
    var productImage: ProductImage?
    var product: Product!
    var didLogIn = false
    var loginUsername: String?
    var loginPassword: String?

    var productByBarcodeCalled = false
    var productByBarcodeScanning: Bool?

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (NSError) -> Void) {
        self.query = query
        self.page = page

        if "Fanta" == query {
            onSuccess(productsResponse)
        } else if "Cancelled" == query {
            onError(cancelledError)
        } else {
            onError(error)
        }
    }

    func getProduct(byBarcode barcode: String, isScanning: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void) {
        productByBarcodeCalled = true
        productByBarcodeScanning = isScanning

        if barcode == "123456789" {
            onSuccess(product)
        } else {
            onError(error)
        }
    }

    func getLanguages() -> [Language] {
        return [Language(code: "en", name: "English")]
    }

    func postImage(_ productImage: ProductImage, barcode: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.productImage = productImage

        if "123456789" == barcode {
            onSuccess()
        } else {
            onError(error)
        }
    }

    func postProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.product = product

        if "123456789" == product.barcode {
            onSuccess()
        } else {
            onError(error)
        }
    }

    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (NSError) -> Void) {
        didLogIn = true

        if username == "test_user" {
            loginUsername = username
            loginPassword = password
            onSuccess()
        } else if username == password {
            let wrongCredentials = NSError(domain: "ProductServiceErrorDomain", code: ProductService.ErrorCodes.wrongCredentials.rawValue, userInfo: nil)
            onError(wrongCredentials)
        } else {
            onError(error)
        }
    }
}
