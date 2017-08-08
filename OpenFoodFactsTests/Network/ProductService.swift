//
//  OpenFoodFactsTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 07/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import OHHTTPStubs

class ProductServiceTests: XCTestCase {

    var productService: ProductService!

    override func setUp() {
        super.setUp()
        productService = ProductService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetProductsForQueryShouldReturnListOfProductsWhenQueryIsNotANumber() {
        var result: ProductsResponse?

        // given
        let query = "Fanta"
        let page = 1
        let success: (ProductsResponse) -> Void = { response in result = response }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isAbsoluteURLString("https://ssl-api.openfoodfacts.org/cgi/search.pl?search_terms=fanta&search_simple=1&action=process&json=1&page=1")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("GetProductsByNameSuccess.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productService.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.products.count) > 0
    }

    func testGetProductsForQueryShouldReturnListOfProductsWhenQueryIsANumber() {
        var result: ProductsResponse?

        // given
        let query = "1234"
        let page = 1
        let success: (ProductsResponse) -> Void = { response in result = response }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isAbsoluteURLString("https://ssl-api.openfoodfacts.org/code/1234xxxxxxxxx.json")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("GetProductsByPartialBarcodeSuccess.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productService.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.products.count) > 0
    }

    func testGetProductsForQueryShouldReturnErrorWhenResponseIsError() {
        var result: NSError?

        // given
        let query = "1234"
        let page = 1
        let success: (ProductsResponse) -> Void = { response in XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        let networkDownErrorCode = -1009
        stub(condition: isAbsoluteURLString("https://ssl-api.openfoodfacts.org/code/1234xxxxxxxxx.json")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:networkDownErrorCode, userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }

        // when
        productService.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.code) == networkDownErrorCode
    }

    func testGetProductByBarcodeShouldSucceedWhenResponseHasProduct() {
        var result: ProductsResponse?

        // given
        let barcode = "5449000011527"
        let success: (ProductsResponse) -> Void = { response in result = response }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/api/v0/product/5449000011527.json")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("GetProductByBarcodeSuccess.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productService.getProduct(byBarcode: barcode, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.product).toNot(beNil())
    }

    func testGetProductByBarcodeShouldFailWhenResponseIsError() {
        var result: NSError?

        // given
        let barcode = "5449000011527"
        let success: (ProductsResponse) -> Void = { response in XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        let networkDownErrorCode = -1009
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/api/v0/product/5449000011527.json")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:networkDownErrorCode, userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }

        // when
        productService.getProduct(byBarcode: barcode, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.code) == networkDownErrorCode
    }
}
