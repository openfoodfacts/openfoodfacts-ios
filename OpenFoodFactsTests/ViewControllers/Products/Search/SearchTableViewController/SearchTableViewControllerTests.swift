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

class SearchTableViewControllerTests: XCTestCase {

    var viewController: SearchTableViewController!
    var productApi: ProductServiceMock!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController // swiftlint:disable:this force_cast
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController // swiftlint:disable:this force_cast
        viewController = navigationController.topViewController as! SearchTableViewController // swiftlint:disable:this force_cast
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
        let expectedProductsResponse = getProductsResponseForJsonFile("GetProductsByNameSuccess")
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
        let firstPageResponse = getProductsResponseForJsonFile("GetProductsByNameSuccess")
        let expectedResponse = getProductsResponseForJsonFile("GetProductsByNameSuccessPage2")
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

    private func getProductsResponseForJsonFile(_ fileName: String) -> ProductsResponse {
        let map = Map(mappingType: .fromJSON, JSON: getJson(fileName)!)
        let productResponse = ProductsResponse(map: map)!
        productResponse.mapping(map: map)
        return productResponse
    }
    
}
