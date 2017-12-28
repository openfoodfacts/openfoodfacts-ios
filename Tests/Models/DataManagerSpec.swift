//
//  DataManagerSpec.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 18/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

// swiftlint:disable function_body_length
class DataManagerSpec: QuickSpec {
    override func spec() {
        var dataManager: DataManager!
        var productApi: ProductServiceMock!
        var persistenceManager: PersistenceManagerMock!

        beforeEach {
            productApi = ProductServiceMock()
            persistenceManager = PersistenceManagerMock()
            dataManager = DataManager()
            dataManager.persistenceManager = persistenceManager
            dataManager.productApi = productApi
        }

        // MARK: - Search

        describe("getProducts()") {
            it("calls product api") {
                let query = "query"
                let page = 1
                let onSuccess: (ProductsResponse) -> Void = { _ in }
                let onError: (Error) -> Void = { _ in }

                dataManager.getProducts(for: query, page: page, onSuccess: onSuccess, onError: onError)

                expect(productApi.getProductsCalled).to(beTrue())
                expect(productApi.query).to(equal(query))
                expect(productApi.page).to(equal(page))
            }
        }

        describe("getProduct()") {
            it("calls product api") {
                let barcode = "123456789"
                let isScanning = true
                let onSuccess: (Product?) -> Void = { _ in }
                let onError: (Error) -> Void = { _ in }

                dataManager.getProduct(byBarcode: barcode, isScanning: isScanning, onSuccess: onSuccess, onError: onError)

                expect(productApi.productByBarcodeCalled).to(beTrue())
                expect(productApi.barcode).to(equal(barcode))
                expect(productApi.productByBarcodeScanning).to(equal(isScanning))
            }
        }

        // MARK: - User

        describe("logIn()") {
            it("calls product api") {
                let username = "username"
                let password = "password"
                let onSuccess: () -> Void = { }
                let onError: (Error) -> Void = { _ in }

                dataManager.logIn(username: username, password: password, onSuccess: onSuccess, onError: onError)

                expect(productApi.loginCalled).to(beTrue())
                expect(productApi.loginUsername).to(equal(username))
                expect(productApi.loginPassword).to(equal(password))
            }
        }

        // MARK: - Search history

        describe("getHistory()") {
            beforeEach {
                let historyItem1 = HistoryItem()
                historyItem1.barcode = "1"
                historyItem1.timestamp = Date()
                let historyItem2 = HistoryItem()
                historyItem2.barcode = "2"
                historyItem2.timestamp = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24 * 28)
                let historyItem3 = HistoryItem()
                historyItem3.barcode = "3"
                historyItem3.timestamp = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24 * 29)
                persistenceManager.history = [historyItem1, historyItem2, historyItem3]
            }

            it("returns a dictionary of history items by age with items ordered by most recent timestmap") {
                let result = dataManager.getHistory()

                expect(persistenceManager.getHistoryCalled).to(beTrue())
                expect(result[.last24h]![0].barcode).to(equal("1"))
                expect(result[.fewWeeks]![0].barcode).to(equal("2"))
                expect(result[.fewWeeks]![1].barcode).to(equal("3"))
            }
        }

        describe("addHistoryItem()") {
            it("saves a new HistoryItem") {
                var product = Product()
                product.barcode = "1"
                product.brands = ["Brand"]

                dataManager.addHistoryItem(product)

                expect(persistenceManager.addHistoryItemCalled).to(beTrue())
                expect(persistenceManager.product?.barcode).to(equal(product.barcode))
            }
        }

        describe("clearHistory()") {
            it("deletes all HistoryItem") {
                dataManager.clearHistory()

                expect(persistenceManager.clearHistoryCalled).to(beTrue())
            }
        }

        // MARK: - Product Add

        describe("addProduct()") {
            it("it calls product api and succeeds") {
                var product = Product()
                product.barcode = "1"
                let onSuccess: () -> Void = { }
                let onError: (Error) -> Void = { _ in XCTFail("Expected success") }

                dataManager.addProduct(product, onSuccess: onSuccess, onError: onError)

                expect(productApi.postProductCalled).to(beTrue())
            }

            it("it calls product api, failes due to no internet and saves product on device for later upload") {
                var product = Product()
                product.barcode = "2"
                let onSuccess: () -> Void = { }
                let onError: (Error) -> Void = { _ in XCTFail("Expected success") }

                dataManager.addProduct(product, onSuccess: onSuccess, onError: onError)

                expect(productApi.postProductCalled).to(beTrue())
                expect(persistenceManager.addPendingUploadItemCalled).to(beTrue())
            }

            it("it calls product api and calls onError") {
                var product = Product()
                product.barcode = "3"
                let onSuccess: () -> Void = { XCTFail("Expected error") }
                let onError: (Error) -> Void = { _ in }

                dataManager.addProduct(product, onSuccess: onSuccess, onError: onError)

                expect(productApi.postProductCalled).to(beTrue())
            }
        }

        describe("postImage()") {
            it("it calls product api and succeeds") {
                let barcode = "1"
                let productImage = ProductImage(barcode: barcode, image: UIImage(), type: .front)
                let onSuccess: (Bool) -> Void = { _ in }
                let onError: (Error) -> Void = { _ in XCTFail("Expected success") }

                dataManager.postImage(productImage, onSuccess: onSuccess, onError: onError)

                expect(productApi.postImageCalled).to(beTrue())
            }

            it("it calls product api, failes due to no internet and saves product on device for later upload") {
                let barcode = "2"
                let productImage = ProductImage(barcode: barcode, image: UIImage(), type: .front)
                let onSuccess: (Bool) -> Void = { _ in }
                let onError: (Error) -> Void = { _ in XCTFail("Expected success") }

                dataManager.postImage(productImage, onSuccess: onSuccess, onError: onError)

                expect(productApi.postImageCalled).to(beTrue())
                expect(persistenceManager.addPendingUploadItemCalled).to(beTrue())
            }

            it("it calls product api and calls onError") {
                let barcode = "3"
                let productImage = ProductImage(barcode: barcode, image: UIImage(), type: .front)
                let onSuccess: (Bool) -> Void = { _ in XCTFail("Expected error") }
                let onError: (Error) -> Void = { _ in }

                dataManager.postImage(productImage, onSuccess: onSuccess, onError: onError)

                expect(productApi.postImageCalled).to(beTrue())
            }
        }

        // MARK: - Products pending upload

        describe("getItemsPendingUpload()") {
            it("calls persistence manager") {
                _ = dataManager.getItemsPendingUpload()

                expect(persistenceManager.getItemsPendingUploadCalled).to(beTrue())
            }
        }
    }
}
