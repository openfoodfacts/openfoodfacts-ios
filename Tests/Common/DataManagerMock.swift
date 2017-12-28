//
//  DataManagerMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 11/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Foundation

class DataManagerMock: DataManagerProtocol {

    // Search
    var query: String?
    var page: Int?
    var productsResponse: ProductsResponse!
    let error = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil)
    let cancelledError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
    var productImage: ProductImage?
    var product: Product!

    // User
    var didLogIn = false
    var loginUsername: String?
    var loginPassword: String?

    var productByBarcodeCalled = false
    var productByBarcodeScanning: Bool?

    // Search history
    var getHistoryCalled = false
    var historyToReturn: [Age: [HistoryItem]]?
    var addHistoyItemCalled = false
    var addHistoryItemProduct: Product?
    var clearHistoryCalled = false
    var getLanguagesCalled = false

    // MARK: - Search
    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
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

    // MARK: - User
    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
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

    // MARK: - Search history
    func getHistory() -> [Age: [HistoryItem]] {
        getHistoryCalled = true
        return historyToReturn ?? [Age: [HistoryItem]]()
    }

    func addHistoryItem(_ product: Product) {
        addHistoyItemCalled = true
        addHistoryItemProduct = product
    }

    func clearHistory() {
        clearHistoryCalled = true
    }

    // MARK: - Product - Add
    func addProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.product = product

        if "123456789" == product.barcode {
            onSuccess()
        } else {
            onError(error)
        }
    }

    func postImage(_ productImage: ProductImage, onSuccess: @escaping (_ isOffline: Bool) -> Void, onError: @escaping (Error) -> Void) {
        self.productImage = productImage

        if "123456789" == productImage.barcode {
            onSuccess(false)
        } else {
            onError(error)
        }
    }

    // MARK: - Products pending upload
    func getItemsPendingUpload() -> [PendingUploadItem] {
        return [PendingUploadItem]()
    }

    // MARK: - Misc
    func getLanguages() -> [Language] {
        getLanguagesCalled = true
        return [Language(code: "en", name: "English")]
    }
}
