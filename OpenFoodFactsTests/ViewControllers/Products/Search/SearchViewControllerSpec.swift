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
class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SearchViewController!

        beforeEach {
            viewController = SearchViewController.loadFromMainStoryboard() as SearchViewController
            viewController.productApi = ProductServiceMock()
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
                it("pushes ProductDetailViewController") {
                    let product: Product! = Product()
                    viewController.showProductDetails(product: product)
                    expect(navigationControllerMock.pushedViewController is ProductDetailViewController).to(beTrue())
                    expect((navigationControllerMock.pushedViewController as! ProductDetailViewController).product).toNot(beNil())
                }
            }

            describe("scanBarcode") {
                it("pushes ScannerViewController") {
                    viewController.scanBarcode(UIBarButtonItem())
                    expect(navigationControllerMock.pushedViewController is ScannerViewController).to(beTrue())
                }
            }
        }
    }
}
