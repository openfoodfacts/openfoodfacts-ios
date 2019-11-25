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
    var searchViewControllerMock: SearchViewControllerMock!
    var dataManager: DataManagerMock!

    private struct ProductsResponseFile {
        static let successPage1 = "GET_ProductsByName_200"
        static let successPage2 = "GET_ProductsByNamePage2_200"
    }

    override func setUp() {
        super.setUp()

        searchViewControllerMock = SearchViewControllerMock()
        viewController = SearchTableViewController.loadFromStoryboard(named: .search) as SearchTableViewController
        dataManager = DataManagerMock()
        dataManager.productsResponse = ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!

        viewController.dataManager = dataManager
        viewController.delegate = searchViewControllerMock

       // UIApplication.shared.keyWindow!.rootViewController = viewController

       // expect(self.viewController.view).notTo(beNil())
    }

    func testInitialState() {
        expect(self.viewController.state).to(beInitial())
    }

    func skiptestInitialBackgroundView() {
        expect(self.viewController.tableView.backgroundView).to(equal(viewController.initialView))
    }

    // MARK: - UITableViewDataSource

    func skiptestNumberOfSectionsWhenStateIsContent() {
        let tableView = viewController.tableView!
        viewController.state = .content(buildProductsResponseForJsonFile(ProductsResponseFile.successPage1))

        let result = viewController.numberOfSections(in: tableView)

        expect(result) == 1
        expect(tableView.separatorStyle.rawValue) == UITableViewCell.SeparatorStyle.singleLine.rawValue
        expect(tableView.isScrollEnabled) == true
    }

    func skiptestNumberOfSectionsWhenStateIsNotContent() {
        let tableView = viewController.tableView!
        viewController.state = .empty

        let result = viewController.numberOfSections(in: tableView)

        expect(result) == 0
        expect(tableView.separatorStyle.rawValue) == UITableViewCell.SeparatorStyle.none.rawValue
        expect(tableView.isScrollEnabled) == false
        expect(tableView.backgroundView?.gestureRecognizers?[0]) === viewController.tapGestureRecognizer
    }

    func skiptestNumberOfRowsInSectionWhenStateIsContent() {
        let tableView = viewController.tableView!
        let section = 1
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        viewController.state = .content(productsResponse)

        let result = viewController.tableView(tableView, numberOfRowsInSection: section)

        expect(result) == productsResponse.products.count + 1
    }

    func skiptestNumberOfRowsInSectionWhenStateIsNotContent() {
        let tableView = viewController.tableView!
        let section = 1
        viewController.state = .initial
        let result = viewController.tableView(tableView, numberOfRowsInSection: section)

        expect(result) == 0
    }

    func skiptestCellForRowAtIndexPathReturnsACell() {
        let tableView = viewController.tableView!
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        let indexPath = IndexPath(row: 0, section: 0)
        let expectedProduct = productsResponse.products[0]
        viewController.state = .content(productsResponse)

        let result = viewController.tableView(tableView, cellForRowAt: indexPath) as! ProductTableViewCell

        expect(result.name.text) == expectedProduct.name
    }

    func skiptestWillDisplayCellForRowAtIndexPathFetchesNextPageWhenAboutToDisplayFifthLastRow() {
        let tableView = viewController.tableView!
        let query = "Fanta"
        let initialPage = 1
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        productsResponse.query = query
        dataManager.productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage2)
        let productIndex = productsResponse.products.count - 5
        let indexPath = IndexPath(row: productIndex, section: 0)
        viewController.state = .content(productsResponse)

        viewController.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)

        expect(self.dataManager.query) == query
        expect(self.dataManager.page) == initialPage
    }

    // MARK: - UITableViewDelegate

    func skiptestDidSelectRowShowsProductDetailWhenStateIsContent() {
        let tableView = viewController.tableView!
        let indexPath = IndexPath(row: 0, section: 0)
        let productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        viewController.state = .content(productsResponse)

        viewController.tableView(tableView, didSelectRowAt: indexPath)

        expect(self.searchViewControllerMock.showProductDetailsCalled).to(beTrue())
        expect(self.searchViewControllerMock.showProductDetailsProduct!.barcode).to(equal(productsResponse.products[0].barcode))
    }

    // MARK: - UISearchResultsUpdating

    func skiptestSearchInputGeneratesQueryForFirstPages() {
        let query = "Fanta"
        let searchBar = viewController.searchController.searchBar
        searchBar.text = query
        viewController.searchBar(searchBar, textDidChange: query)

        viewController.updateSearchResults(for: viewController.searchController)

        expect(self.dataManager.query).toEventually(equal(query), timeout: 5)
        expect(self.dataManager.page).toEventually(equal(1), timeout: 5)
    }

    // MARK: - UISearchBarDelegate

    func skiptestClearingSearchBarReturnsToInitialState() {
        let query = "Fanta"
        let searchBar = viewController.searchController.searchBar
        searchBar.text = query
        viewController.state = .content(ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!)

        viewController.searchBar(searchBar, textDidChange: "")

        expect(self.viewController.state).to(beInitial())
    }

    func skiptestTappingSearchBarCancelButtonReturnsToInitialState() {
        let query = "Fanta"
        let searchBar = viewController.searchController.searchBar
        searchBar.text = query
        viewController.state = .content(ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!)

        viewController.searchBarCancelButtonClicked(searchBar)

        expect(self.viewController.state).to(beInitial())
    }

    func skiptestEditingSearchBarShowsCancelButton() {
        let searchBar = viewController.searchController.searchBar
        expect(searchBar.showsCancelButton).to(beFalse())

        viewController.searchBarTextDidBeginEditing(searchBar)

        expect(self.viewController.searchController.searchBar.showsCancelButton).to(beTrue())
    }

    func skiptestFinishEditingSearchBarHidesCancelButton() {
        let searchBar = viewController.searchController.searchBar
        searchBar.showsCancelButton = true

        viewController.searchBarTextDidEndEditing(searchBar)

        expect(self.viewController.searchController.searchBar.showsCancelButton).to(beFalse())
    }

    // MARK: - Data source

    func skiptestGetProductsChangesStateToContentWhenGotNewResponse() {
        let page = 1
        let query = "Fanta"
        let expectedProductsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        dataManager.productsResponse = expectedProductsResponse
        viewController.state = .loading

        viewController.getProducts(page: page, withQuery: query)

        expect(self.dataManager.page) == page
        expect(self.dataManager.query) == query
        expect(self.viewController.state).to(beContent { response in
            expect(response) === expectedProductsResponse
        })
    }

    func skiptestGetProductsChangesStateToEmptyWhenResponseIsEmpty() {
        let page = 1
        let query = "Fanta"
        viewController.state = .loading

        viewController.getProducts(page: page, withQuery: query)

        expect(self.viewController.state).to(beEmpty())
    }

    func skiptestGetProductsAppendsResponseWhenStatusAlreadyIsContent() {
        let page = 2
        let query = "Fanta"
        let firstPageResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        firstPageResponse.query = query
        let expectedResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage2)
        expectedResponse.query = query
        let expectedProductsCount = firstPageResponse.products.count + expectedResponse.products.count
        dataManager.productsResponse = expectedResponse
        viewController.state = .content(firstPageResponse)

        viewController.getProducts(page: page, withQuery: query)

        expect(self.dataManager.page) == page
        expect(self.dataManager.query) == query
        expect(self.viewController.state).to(beContent { response in
            expect(response.totalProducts) == expectedResponse.totalProducts
            expect(response.page) == expectedResponse.page
            expect(response.products.count) == expectedProductsCount
        })
    }

    func skiptestGetProductsChangesStateToErrorWhenApiCallFails() {
        let page = 1
        let query = "NotAFanta"

        viewController.getProducts(page: page, withQuery: query)

        expect(self.dataManager.page) == page
        expect(self.dataManager.query) == query
        expect(self.viewController.state).to(beError { error in
            expect(error) === self.dataManager.error as Error
        })
    }

    func skiptestGetProductsShouldNotChangeStateWhenResponseReceivedAndStateNotContentOrLoading() {
        let page = 1
        let query = "Fanta"
        dataManager.productsResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        viewController.state = .error(dataManager.error)

        viewController.getProducts(page: page, withQuery: query)

        expect(self.viewController.state).to(beError { error in
            expect(error) === self.dataManager.error as Error
        })
    }

    func skiptestGetProductsShouldNotChangeStateWhenErrorDueToCancelledRequest() {
        let page = 1
        let query = "Cancelled"
        viewController.state = .loading

        viewController.getProducts(page: page, withQuery: query)

        expect(self.viewController.state).to(beLoading())
    }

    func skiptestGetProductsShouldSetNewResponseWhenStateIsContentButNewResponseIsForDifferentQuery() {
        let page  = 1
        let query = "Water"
        let secondQuery = "Fanta"
        let productResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        productResponse.query = query
        let secondProductResponse = buildProductsResponseForJsonFile(ProductsResponseFile.successPage1)
        productResponse.query = secondQuery
        dataManager.productsResponse = secondProductResponse
        viewController.state = .content(productResponse)

        viewController.getProducts(page: page, withQuery: secondQuery)

        expect(self.viewController.state).to(beContent(test: { response in
            expect(response.query).to(equal(secondQuery))
        }))
    }

    // MARK: - Gesture recognizers

    func skiptestDidTapTableViewBackgroundDismissesSearchBarWhenStateIsNotContentAndSearchBarHasNoText() {
        viewController.state = .initial
        viewController.searchController.isActive = true
        viewController.searchController.searchBar.becomeFirstResponder()

        viewController.didTapTableViewBackground(UITapGestureRecognizer(target: nil, action: nil))

        expect(self.viewController.searchController.searchBar.isFirstResponder) == false
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

    private func beLoading() -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be <loading>") { expression, message in
            if let actual = try expression.evaluate(), case .loading = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    // MARK: - Helper functions

    private func buildProductsResponseForJsonFile(_ fileName: String) -> ProductsResponse {
        let map = Map(mappingType: .fromJSON, JSON: TestHelper.sharedInstance.getJson(fileName))
        let productResponse = ProductsResponse(map: map)!
        productResponse.mapping(map: map)
        return productResponse
    }
}

class SearchViewControllerMock: SearchViewControllerDelegate {
    var showProductDetailsCalled = false
    var showProductDetailsProduct: Product?

    func showProductDetails(product: Product) {
        showProductDetailsCalled = true
        showProductDetailsProduct = product
    }
}
