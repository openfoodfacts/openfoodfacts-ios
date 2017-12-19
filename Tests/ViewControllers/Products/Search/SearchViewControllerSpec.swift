//
//  SearchViewControllerSpec.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 10/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

// swiftlint:disable force_cast
// swiftlint:disable function_body_length
class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SearchViewController!
        var dataManager: DataManagerMock!
        var productApi: ProductServiceMock!

        beforeEach {
            dataManager = DataManagerMock()
            productApi = ProductServiceMock()
            viewController = SearchViewController.loadFromMainStoryboard() as SearchViewController
            viewController.productApi = productApi
            viewController.dataManager = dataManager
            expect(viewController.view).toNot(beNil())
        }

        describe("viewDidLoad()") {
            it("shows search tvc") {
                expect(viewController.childViewControllers[0] is UINavigationController).to(beTrue())
                let nav = viewController.childViewControllers[0] as! UINavigationController
                expect(nav.childViewControllers[0] is SearchTableViewController).to(beTrue())
                let searchTVC = nav.childViewControllers[0] as! SearchTableViewController
                expect(searchTVC.navigationItem.rightBarButtonItems![0].action).to(equal(#selector(SearchViewController.scanBarcode(_:))))
            }
        }

        context("mocked navigation controller") {
            var navigationControllerMock: UINavigationControllerMock!
            beforeEach {
                navigationControllerMock = UINavigationControllerMock()
                viewController.rootNavigationController = navigationControllerMock
            }

            describe("showProductDetails()") {
                var product: Product!
                let barcode = "1"

                beforeEach {
                    product = Product()
                    product.barcode = barcode
                    viewController.showProductDetails(product: product)
                }
                it("pushes ProductDetailViewController") {
                    expect(navigationControllerMock.pushedViewController is ProductDetailViewController).to(beTrue())
                    expect((navigationControllerMock.pushedViewController as! ProductDetailViewController).product).toNot(beNil())
                }

                it("saves product in search history") {
                    expect(dataManager.addHistoyItemCalled).to(beTrue())
                    expect(dataManager.addHistoryItemProduct?.barcode).to(equal(barcode))
                }
            }

            describe("scanBarcode()") {
                it("pushes ScannerViewController") {
                    viewController.scanBarcode(UIBarButtonItem())
                    expect(navigationControllerMock.pushedViewController is ScannerViewController).to(beTrue())
                }
            }

            describe("showHistory()") {
                it("pushes HistoryTableViewController") {
                    viewController.showHistory(UIBarButtonItem())

                    expect(navigationControllerMock.pushedViewController is HistoryTableViewController).to(beTrue())
                    let vc = navigationControllerMock.pushedViewController as! HistoryTableViewController
                    expect(vc.dataManager).toNot(beNil())
                    expect(vc.delegate).toNot(beNil())
                }
            }

            describe("showItem()") {
                context("API call succeeds") {
                    let barcode = "123456789"
                    var errorCalled = false

                    beforeEach {
                        productApi.product = Product()
                        productApi.product.barcode = barcode
                        let item = HistoryItem()
                        item.barcode = barcode

                        viewController.showItem(item) {
                            errorCalled = true
                        }
                    }

                    it("fetches item from server") {
                        productApi.product = Product()

                        expect(productApi.productByBarcodeCalled).to(beTrue())
                    }

                    it("pushes DetailViewController") {
                        expect(navigationControllerMock.pushedViewController is ProductDetailViewController).to(beTrue())
                    }

                    it ("does not call onError") {
                        expect(errorCalled).to(beFalse())
                    }
                }

                context("API call succeeds but product is nil") {
                    let barcode = "123456789"
                    var errorCalled = false

                    beforeEach {
                        productApi.product = nil
                        let item = HistoryItem()
                        item.barcode = barcode

                        viewController.showItem(item) {
                            errorCalled = true
                        }
                    }

                    it("shows error when API call succeeds but product is nil") {
                        productApi.product = nil

                        expect(errorCalled).to(beTrue())
                    }
                }

                context("API call fails") {
                    let barcode = "987654321"
                    var errorCalled = false

                    beforeEach {
                        let item = HistoryItem()
                        item.barcode = barcode
                        viewController.showItem(item) {
                            errorCalled = true
                        }
                    }

                    it("shows error") {
                        expect(errorCalled).to(beTrue())
                    }
                }
            }
        }
    }
}
