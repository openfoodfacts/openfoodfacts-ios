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

                expect(productApi.productByBarcodeCount).to(equal(1))
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
                guard let productImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .front) else { XCTFail("A non nil ProductImage is required for the test"); return }
                let onSuccess: (Bool) -> Void = { _ in }
                let onError: (Error) -> Void = { _ in XCTFail("Expected success") }

                dataManager.postImage(productImage, onSuccess: onSuccess, onError: onError)

                expect(productApi.postImageCount).to(equal(1))
            }

            it("it calls product api, failes due to no internet and saves product on device for later upload") {
                let barcode = "2"
                guard let productImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .front) else { XCTFail("A non nil ProductImage is required for the test"); return }
                let onSuccess: (Bool) -> Void = { _ in }
                let onError: (Error) -> Void = { _ in XCTFail("Expected success") }

                dataManager.postImage(productImage, onSuccess: onSuccess, onError: onError)

                expect(productApi.postImageCount).to(equal(1))
                expect(persistenceManager.addPendingUploadItemCalled).to(beTrue())
            }

            it("it calls product api and calls onError") {
                let barcode = "3"
                guard let productImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .front) else { XCTFail("A non nil ProductImage is required for the test"); return }
                let onSuccess: (Bool) -> Void = { _ in XCTFail("Expected error") }
                let onError: (Error) -> Void = { _ in }

                dataManager.postImage(productImage, onSuccess: onSuccess, onError: onError)

                expect(productApi.postImageCount).to(equal(1))
            }
        }

        // MARK: - Products pending upload

        describe("getItemsPendingUpload()") {
            it("calls persistence manager") {
                _ = dataManager.getItemsPendingUpload()

                expect(persistenceManager.getItemsPendingUploadCalled).to(beTrue())
            }
        }

        describe(".getItemPendingUpload()") {
            let barcode = "123456789"
            beforeEach {
                _ = dataManager.getItemPendingUpload(forBarcode: barcode)
            }

            it("passes the call to persistance manager") {
                expect(persistenceManager.getItemPendingUploadCalled).to(beTrue())
                expect(persistenceManager.getItemPendingUploadBarcode).to(equal(barcode))
            }
        }

        describe(".uploadPendingItems()") {
            context("when persistenceManager returns an empty array") {
                beforeEach {
                    dataManager.uploadPendingItems { _ in }
                }

                it("does not call product service") {
                    expect(productApi.productByBarcodeCount).to(equal(0))
                }
            }

            context("when persistenceManager returns an array with several items") {
                beforeEach {
                    let item1 = PendingUploadItem(barcode: "1")
                    let item2 = PendingUploadItem(barcode: "2")
                    persistenceManager.itemsPendingUpload = [item1, item2]
                }

                context("when there is internet connection") {
                    beforeEach {
                        dataManager.uploadPendingItems { _ in }
                    }

                    it("checks if every item exists on server") {
                        expect(productApi.productByBarcodeCount).toEventually(equal(2))
                    }
                }

                context("when there is no internet connection") {
                    beforeEach {
                        let item1 = PendingUploadItem(barcode: "no_connection_1")
                        let item2 = PendingUploadItem(barcode: "no_connection_2")
                        persistenceManager.itemsPendingUpload = [item1, item2]

                        dataManager.uploadPendingItems { _ in }
                    }

                    it("calls product service for each item") {
                        expect(productApi.productByBarcodeCount).toEventually(equal(2))
                    }

                    it("does not call post product") {
                        expect(productApi.postProductCalled).toEventually(beFalse())
                    }

                    it("does not call post image") {
                        expect(productApi.postImageCount).toEventually(equal(0))
                    }
                }
            }

            context("when persistenceManager returns an array with one item") {
                let barcode = "1"
                let name = "product_name"
                let brand = "brand"
                let quantityValue = "33"
                let quantityUnit = "cl"
                let language = "de"

                beforeEach {
                    let item1 = PendingUploadItem(barcode: barcode)
                    item1.productName = name
                    item1.brand = brand
                    item1.quantityValue = quantityValue
                    item1.quantityUnit = quantityUnit
                    item1.language = language
                    item1.frontImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .front)!
                    item1.ingredientsImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .ingredients)!
                    item1.nutritionImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .nutrition)!

                    persistenceManager.itemsPendingUpload = [item1]
                }

                context("when product exists on server") {
                    beforeEach {
                        productApi.product = Product()
                        productApi.product?.barcode = barcode
                    }

                    context("when product on the server is incomplete") {
                        beforeEach {
                            dataManager.uploadPendingItems { _ in }
                        }

                        it("calls posts the product") {
                            expect(productApi.postProductCalled).toEventually(beTrue())
                        }

                        it("uploads the product as is") {
                            expect(productApi.product?.name).toEventually(equal(name))
                            expect(productApi.product?.brands).toEventually(equal([brand]))
                            expect(productApi.product?.quantity).toEventually(equal("\(quantityValue) \(quantityUnit)"))
                            expect(productApi.product?.lang).toEventually(equal(language))
                        }

                        it("calls post image for each picture") {
                            expect(productApi.postImageCount).toEventually(equal(3))
                        }

                        it("deletes pending upload item") {
                            expect(persistenceManager.deletePendingUploadItemCalled).toEventually(beTrue())
                        }
                    }

                    context("when product on the server is complete") {
                        beforeEach {
                            productApi.product?.name = name
                            productApi.product?.brands = [brand]
                            productApi.product?.quantityValue = quantityValue
                            productApi.product?.quantityUnit = quantityUnit
                            productApi.product?.lang = language

                            dataManager.uploadPendingItems { _ in }
                        }

                        it("does not call post product") {
                            expect(productApi.postProductCalled).toEventually(beFalse())
                        }
                    }
                }

                context("when product does not exist on server") {
                    describe("item is complete") {
                        beforeEach {
                            dataManager.uploadPendingItems { _ in }
                        }

                        it("posts the product") {
                            expect(productApi.postProductCalled).toEventually(beTrue())
                        }

                        it("uploads the product as is") {
                            expect(productApi.product?.name).toEventually(equal(name))
                            expect(productApi.product?.brands).toEventually(equal([brand]))
                            expect(productApi.product?.quantity).toEventually(equal("\(quantityValue) \(quantityUnit)"))
                            expect(productApi.product?.lang).toEventually(equal(language))
                        }

                        it("calls post image for each picture") {
                            expect(productApi.postImageCount).toEventually(equal(3))
                        }

                        it("deletes pending upload item") {
                            expect(persistenceManager.deletePendingUploadItemCalled).toEventually(beTrue())
                        }
                    }

                    describe("item does not have ingredients and nutrition images") {
                        beforeEach {
                            let barcode = "4"
                            let item1 = PendingUploadItem(barcode: barcode)
                            item1.productName = name
                            item1.brand = brand
                            item1.quantityValue = quantityValue
                            item1.quantityUnit = quantityUnit
                            item1.language = language
                            item1.frontImage = ProductImage(barcode: barcode, image: TestHelper.sharedInstance.getTestImage(), type: .front)!

                            persistenceManager.itemsPendingUpload = [item1]
                        }

                        describe("when post image fails") {
                            beforeEach {
                                dataManager.uploadPendingItems { _ in }
                            }

                            it("posts the product") {
                                expect(productApi.postProductCalled).toEventually(beTrue())
                            }

                            it("calls post image for each picture") {
                                expect(productApi.postImageCount).toEventually(equal(1))
                            }

                            it("calls persistenceManager, updating the item") {
                                expect(persistenceManager.updatePendingUploadItemCalled).toEventually(beTrue())
                            }

                            it("removes from updated item all the info that was successfully posted") {
                                expect(persistenceManager.pendingUploadItem?.productName).toEventually(beNil())
                                expect(persistenceManager.pendingUploadItem?.brand).toEventually(beNil())
                                expect(persistenceManager.pendingUploadItem?.quantityValue).toEventually(beNil())
                                expect(persistenceManager.pendingUploadItem?.quantityUnit).toEventually(beNil())
                            }

                            it("saves the info that was not successfully posted") {
                                expect(persistenceManager.pendingUploadItem?.frontImage).toEventuallyNot(beNil())
                            }
                        }
                    }
                }
            }
        }

        // MARK: - Misc

        describe(".getLanguages()") {
            var languages: [Language]?

            beforeEach {
                languages = dataManager.getLanguages()
            }

            it("returns a non-empty list of languages") {
                expect(languages?.isEmpty).to(beFalse())
            }
        }
    }
}
