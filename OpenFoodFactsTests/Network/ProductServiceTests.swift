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

fileprivate let networkDownErrorCode = -1009

class ProductServiceTests: XCTestCase {

    var productApi: ProductApi!

    override func setUp() {
        super.setUp()
        productApi = ProductService()
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
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
        productApi.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.products.count) > 0
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
        productApi.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.products.count) > 0
    }

    func testGetProductsForQueryShouldReturnErrorWhenConnectionFails() {
        var result: NSError?

        // given
        let query = "1234"
        let page = 1
        let success: (ProductsResponse) -> Void = { response in XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isAbsoluteURLString("https://ssl-api.openfoodfacts.org/code/1234xxxxxxxxx.json")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:networkDownErrorCode, userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }

        // when
        productApi.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
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
        productApi.getProduct(byBarcode: barcode, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.product).toNot(beNil())
    }

    func testGetProductByBarcodeShouldFailWhenConnectionFails() {
        var result: NSError?

        // given
        let barcode = "5449000011527"
        let success: (ProductsResponse) -> Void = { response in XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/api/v0/product/5449000011527.json")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:networkDownErrorCode, userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }

        // when
        productApi.getProduct(byBarcode: barcode, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
    }

    func testPostImageShouldSucceed() {
        var resultSuccessful = false

        // given
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "test_image", ofType: "jpg") else { XCTFail("Couldn't find test image file"); return }
        var imageFromFile: UIImage?
        do {
            let data = try NSData(contentsOfFile: path) as Data
            imageFromFile = UIImage(data: data)
        } catch {
            XCTFail("Error loading test image")
        }
        guard let image = imageFromFile else { XCTFail("Instance of UIImage with test image could not be created"); return }
        let productImage = ProductImage(image: image, type: .front)
        let barcode = "5449000011527"
        let success: () -> Void = { resultSuccessful = true }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/cgi/product_image_upload.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("PostImageSuccess.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productApi.postImage(productImage, barcode: barcode, onSuccess: success, onError: error)

        // then
        expect(resultSuccessful).toEventually(beTrue())
    }

    func testPostImageShouldFailWhenConnectionFails() {
        var result: NSError?

        // given
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "test_image", ofType: "jpg") else { XCTFail("Couldn't find test image file"); return }
        var imageFromFile: UIImage?
        do {
            let data = try NSData(contentsOfFile: path) as Data
            imageFromFile = UIImage(data: data)
        } catch {
            XCTFail("Error loading test image")
        }
        guard let image = imageFromFile else { XCTFail("Instance of UIImage with test image could not be created"); return }
        let productImage = ProductImage(image: image, type: .front)
        let barcode = "5449000011527"
        let success: () -> Void = { XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/cgi/product_image_upload.pl")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:networkDownErrorCode, userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }

        // when
        productApi.postImage(productImage, barcode: barcode, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
    }

    func testPostImageShouldFailWhenResponseContainsError() {
        var result: NSError?

        // given
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "test_image", ofType: "jpg") else { XCTFail("Couldn't find test image file"); return }
        var imageFromFile: UIImage?
        do {
            let data = try NSData(contentsOfFile: path) as Data
            imageFromFile = UIImage(data: data)
        } catch {
            XCTFail("Error loading test image")
        }
        guard let image = imageFromFile else { XCTFail("Instance of UIImage with test image could not be created"); return }
        let productImage = ProductImage(image: image, type: .front)
        let barcode = "5449000011527"
        let success: () -> Void = { XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/cgi/product_image_upload.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("PostImageFailure.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productApi.postImage(productImage, barcode: barcode, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.code) == 1
        expect(result!.domain) == "ProductServiceErrorDomain"
    }

    func testPostProductShouldSucceed() {
        var resultSuccessful = false

        // given
        let product = Product()
        let success: () -> Void = { resultSuccessful = true }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/cgi/product_jqm2.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("PostProductSuccess.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productApi.postProduct(product, onSuccess: success, onError: error)

        // then
        expect(resultSuccessful).toEventually(beTrue())
    }

    func testPostProductShouldFailWhenConnectionFails() {
        var result: NSError?

        // given
        let product = Product()
        let success: () -> Void = { XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isAbsoluteURLString("https://world.openfoodfacts.net/cgi/product_jqm2.pl")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:networkDownErrorCode, userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }

        // when
        productApi.postProduct(product, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
    }
}
