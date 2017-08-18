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
        productApi.productResponse = ProductsResponse(map: Map(mappingType: .fromJSON, JSON: [String: Any]()))!

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
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "GetProductsByNameSuccess", withExtension: "json") else { XCTFail("Failed to get json file"); return }
        guard let data = try? Data(contentsOf: url) else { XCTFail("Failed to read json file"); return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { XCTFail("Failed to parse json"); return }
        guard let json = jsonObject as? [String: Any] else { XCTFail("Failed to cast json"); return }
        let map = Map(mappingType: .fromJSON, JSON: json)
        let productResponse = ProductsResponse(map: map)!
        productResponse.mapping(map: map)
        productApi.productResponse = productResponse
        viewController.getProducts(page: page, withQuery: query)

        expect(self.viewController.state).to(beContent { response in
            expect(response) === productResponse
        })
    }

    func testGetProductsChangesStateToEmptyWhenResponseIsEmpty() {
        let page = 1
        let query = "Fanta"
        viewController.getProducts(page: page, withQuery: query)

        expect(self.viewController.state).to(beEmpty())
    }

    func testGetProductsAppendsResponseWhenStatusAlreadyIsContent() {
        // TODO
    }

    func testGetProductsChangesStateToErrorWhenApiCallFails() {
        // TODO
    }

    private func beInitial() -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be Initial") { expression, message in
            if let actual = try expression.evaluate(), case .initial = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    private func beEmpty() -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be Empty") { expression, message in
            if let actual = try expression.evaluate(), case .empty = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }

    private func beContent(test: @escaping (ProductsResponse) -> Void = { _ in }) -> Predicate<SearchTableViewController.State> {
        return Predicate.define("be Content") { expression, message in
            if let actual = try expression.evaluate(),
                case let .content(productResponse) = actual {
                test(productResponse)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
}
