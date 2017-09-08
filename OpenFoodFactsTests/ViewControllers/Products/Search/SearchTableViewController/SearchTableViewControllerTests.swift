//
//  SearchTableViewControllerTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import ObjectMapper

// swiftlint:disable force_cast
class SearchTableViewControllerTests: XCTestCase {

    var viewController: SearchTableViewController!
    var productApi: ProductServiceMock!

    private struct ProductsResponseFile {
        static let successPage1 = "GET_ProductsByName_200"
        static let successPage2 = "GET_ProductsByNamePage2_200"
    }

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController
        viewController = navigationController.topViewController as! SearchTableViewController
        productApi = ProductServiceMock()
        productApi.productsResponse = ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!

        viewController.productApi = productApi

        UIApplication.shared.keyWindow!.rootViewController = viewController

        expect(navigationController.view).notTo(beNil())
        expect(self.viewController.view).notTo(beNil())
    }

    func testInitialState() {
        expect(self.viewController.state).to(beInitial())
    }

    func testInitialBackgroundView() {
        expect(self.viewController.tableView.backgroundView).to(equal(viewController.initialView))
    }

    // MARK: - UITableViewDataSource

    func testNumberOfSectionsWhenStateIsContent() {
        let tableView = viewController.tableView!
        viewController.state = .content(buildProductsResponseForJsonFile(ProductsResponseFile.successPage1))

        let result = viewController.numberOfSections(in: tableView)

        expect(result) == 1
        expect(tableView.separatorStyle.rawValue) == UITableViewCellSeparatorStyle.singleLine.rawValue
        expect(tableView.isScrollEnabled) == true
    }

    func testNumberOfSectionsWhenStateIsNotContent() {
        let tableView = viewController.tableView!
        viewController.state = .empty

        let result = viewController.numberOfSections(in: tableView)

        expect(result) == 0
        expect(tableView.separatorStyle.rawValue) == UITableViewCellSeparatorStyle.none.rawValue
        expect(tableView.isScrollEnabled) == false
        expect(tableView.backgroundView?.gestureRecognizers?[0]) === viewController.tapGestureRecognizer
    }

    func testNumberOfRowsInSectionWhenStateIsContent() {
        let tableView = viewController.tableView!
        let section = 1
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        viewController.state = .content(productsResponse)

        let result = viewController.tableView(tableView, numberOfRowsInSection: section)

        expect(result) == productsResponse.products.count + 1
    }

    func testNumberOfRowsInSectionWhenStateIsNotContent() {
        let tableView = viewController.tableView!
        let section = 1
        viewController.state = .initial
        let result = viewController.tableView(tableView, numberOfRowsInSection: section)

        expect(result) == 0
    }

    func testCellForRowAtIndexPathReturnsACell() {
        let tableView = viewController.tableView!
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        let indexPath = IndexPath(row: 0, section: 0)
        let expectedProduct = productsResponse.products[0]
        viewController.state = .content(productsResponse)

        let result = viewController.tableView(tableView, cellForRowAt: indexPath) as! ProductTableViewCell

        expect(result.name.text) == expectedProduct.name
    }

    func testWillDisplayCellForRowAtIndexPathFetchesNextPageWhenAboutToDisplayFifthLastRow() {
        let tableView = viewController.tableView!
        let query = "Fanta"
        let initialPage = "1"
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        productsResponse.query = query
        productApi.productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage2)
        let productIndex = productsResponse.products.count - 5
        let indexPath = IndexPath(row: productIndex, section: 0)
        viewController.state = .content(productsResponse)

        viewController.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)

        expect(self.productApi.query) == query
        expect(self.productApi.page) == Int(initialPage)! + 1
    }

    // MARK: - UITableViewDelegate

    func testDidSelectRowShowsProductDetailWhenStateIsContent() {
        let tableView = viewController.tableView!
        let indexPath = IndexPath(row: 0, section: 0)
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        viewController.state = .content(productsResponse)

        viewController.tableView(tableView, didSelectRowAt: indexPath)

        expect(self.viewController.navigationController?.topViewController).toEventually(beAnInstanceOf(ProductDetailViewController.self))
    }

    // MARK: - UISearchResultsUpdating

    func testSearchInputGeneratesQueryForFirstPages() {
        let query = "Fanta"
        let searchBar = viewController.searchController.searchBar
        searchBar.text = query
        viewController.searchBar(searchBar, textDidChange: query)

        viewController.updateSearchResults(for: viewController.searchController)

        expect(self.productApi.query).toEventually(equal(query))
        expect(self.productApi.page).toEventually(equal(1))
    }

    // MARK: - UISearchBarDelegate

    func testClearingSearchBarReturnsToInitialState() {
        let query = "Fanta"
        let searchBar = viewController.searchController.searchBar
        searchBar.text = query
        viewController.state = .content(ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!)

        viewController.searchBar(searchBar, textDidChange: "")

        expect(self.viewController.state).to(beInitial())
    }

    func testTappingSearchBarCancelButtonReturnsToInitialState() {
        let query = "Fanta"
        let searchBar = viewController.searchController.searchBar
        searchBar.text = query
        viewController.state = .content(ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!)

        viewController.searchBarCancelButtonClicked(searchBar)

        expect(self.viewController.state).to(beInitial())
    }

    func testEditingSearchBarShowsCancelButton() {
        let searchBar = viewController.searchController.searchBar
        expect(searchBar.showsCancelButton).to(beFalse())

        viewController.searchBarTextDidBeginEditing(searchBar)

        expect(self.viewController.searchController.searchBar.showsCancelButton).to(beTrue())
    }

    func testFinishEditingSearchBarHidesCancelButton() {
        let searchBar = viewController.searchController.searchBar
        searchBar.showsCancelButton = true

        viewController.searchBarTextDidEndEditing(searchBar)

        expect(self.viewController.searchController.searchBar.showsCancelButton).to(beFalse())
    }

    // MARK: - Data source

    func testGetProductsChangesStateToContentWhenGotNewResponse() {
        let page = 1
        let query = "Fanta"
        let expectedProductsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        productApi.productsResponse = expectedProductsResponse

        viewController.getProducts(page: page, withQuery: query)

        expect(self.productApi.page) == page
        expect(self.productApi.query) == query
        expect(self.viewController.state).to(beContent { response in
            expect(response) === expectedProductsResponse
        })
    }

    func testGetProductsChangesStateToEmptyWhenResponseIsEmpty() {
        let page = 1
        let query = "Fanta"

        viewController.getProducts(page: page, withQuery: query)

        expect(self.viewController.state).to(beEmpty())
    }

    func testGetProductsAppendsResponseWhenStatusAlreadyIsContent() {
        let page = 2
        let query = "Fanta"
        let firstPageResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        firstPageResponse.query = query
        let expectedResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage2)
        expectedResponse.query = query
        let expectedProductsCount = firstPageResponse.products.count + expectedResponse.products.count
        productApi.productsResponse = expectedResponse
        viewController.state = .content(firstPageResponse)

        viewController.getProducts(page: page, withQuery: query)

        expect(self.productApi.page) == page
        expect(self.productApi.query) == query
        expect(self.viewController.state).to(beContent { response in
            expect(response.totalProducts) == expectedResponse.totalProducts
            expect(response.page) == String(page)
            expect(response.products.count) == expectedProductsCount
        })
    }

    func testGetProductsChangesStateToErrorWhenApiCallFails() {
        let page = 1
        let query = "NotAFanta"

        viewController.getProducts(page: page, withQuery: query)

        expect(self.productApi.page) == page
        expect(self.productApi.query) == query
        expect(self.viewController.state).to(beError { error in
            expect(error) === self.productApi.error as Error
        })
    }

    // MARK: - Gesture recognizers

    func testDidTapTableViewBackgroundDismissesSearchBarWhenStateIsNotContentAndSearchBarHasNoText() {
        viewController.state = .initial
        viewController.searchController.isActive = true
        viewController.searchController.searchBar.becomeFirstResponder()

        viewController.didTapTableViewBackground(UITapGestureRecognizer(target: nil, action: nil))

        expect(self.viewController.searchController.searchBar.isFirstResponder) == false
    }

    // MARK: - Scanning

    func testScanBarcodePushesScannerViewController() {
        viewController.scanBarcode()

        expect(self.viewController.navigationController?.topViewController).toEventually(beAnInstanceOf(ScannerViewController.self))
        let targetViewController = self.viewController.navigationController?.topViewController as! ScannerViewController
        expect(targetViewController.productApi) === productApi
    }

    // MARK: - Custom matchers

    private func beInitial() -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be <initial>") { expression, message in
            if let actual = try expression.evaluate(), case .initial = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    private func beEmpty() -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be <empty>") { expression, message in
            if let actual = try expression.evaluate(), case .empty = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    private func beContent(test: @escaping (ProductsResponse) -> Void = { _ in }) -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be <content>") { expression, message in
            if let actual = try expression.evaluate(),
                case let .content(productResponse) = actual {
                test(productResponse)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    private func beError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be <error>") { expression, message in
            if let actual = try expression.evaluate(),
                case let .error(error) = actual {
                test(error)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    // MARK: - Helper functions
    private func getJson(_ fileName: String) -> [String: Any]? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else { fail("Failed to get json file: \(fileName)"); return nil }
        guard let data = try? Data(contentsOf: url) else { fail("Failed to read json file"); return nil }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { fail("Failed to parse json"); return nil }
        guard let json = jsonObject as? [String: Any] else { fail("Failed to cast json"); return nil }
        return json
    }

    private func buildProductsResponseForJsonFile(_ fileName: String) -> ProductsResponse {
        let map = Map(mappingType: .fromJSON, JSON: getJson(fileName)!)
        let productResponse = ProductsResponse(map: map)!
        productResponse.mapping(map: map)
        return productResponse
    }
}
