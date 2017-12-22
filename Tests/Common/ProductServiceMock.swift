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

    var query: String?
    var page: Int?
    var getProductsCalled = false
    var productByBarcodeCalled = false
    var productByBarcodeScanning: Bool?
    var barcode: String?
    var productImage: ProductImage?
    var postImageCalled = false
    var product: Product?
    var postProductCalled = false
    var loginCalled = false
    var loginUsername: String?
    var loginPassword: String?

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        self.query = query
        self.page = page
        getProductsCalled = true
    }

    func getProduct(byBarcode barcode: String, isScanning: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void) {
        self.barcode = barcode
        productByBarcodeCalled = true
        productByBarcodeScanning = isScanning
    }

    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.productImage = productImage
        postImageCalled = true

        if productImage.barcode == "2" {
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

    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        loginCalled = true
        loginUsername = username
        loginPassword = password
    }
}
