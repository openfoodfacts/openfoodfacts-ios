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

private let networkDownErrorCode = -1009

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

    // MARK: - getProductsForQuery
    func testGetProductsForQueryShouldReturnListOfProductsWhenQueryIsNotANumber() {
        var result: ProductsResponse?

        // given
        let query = "Fanta"
        let page = 1
        let success: (ProductsResponse) -> Void = { response in result = response }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isPath("/cgi/search.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("GET_ProductsByName_200.json", type(of: self))!,
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
        stub(condition: isPath("/code/1234xxxxxxxxx.json")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("GET_ProductsByPartialBarcode_200.json", type(of: self))!,
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
        stub(condition: isPath("/code/1234xxxxxxxxx.json")) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: networkDownErrorCode, userInfo: nil)
            return OHHTTPStubsResponse(error: notConnectedError)
        }

        // when
        productApi.getProducts(for: query, page: page, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
    }

    func testGetProductByBarcodeShouldSucceedWhenResponseHasProduct() {
        var result: Product?

        // given
        let barcode = "5449000011527"
        let success: (Product?) -> Void = { response in result = response }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isPath("/api/v0/product/5449000011527.json")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("GET_ProductsByBarcode_200.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productApi.getProduct(byBarcode: barcode, isScanning: true, isSummary: false, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
    }

    // MARK: - getProductByBarcode
    func testGetProductByBarcodeShouldFailWhenConnectionFails() {
        var result: NSError?

        // given
        let barcode = "5449000011527"
        let success: (Product?) -> Void = { response in XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isPath("/api/v0/product/5449000011527.json")) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: networkDownErrorCode, userInfo: nil)
            return OHHTTPStubsResponse(error: notConnectedError)
        }

        // when
        productApi.getProduct(byBarcode: barcode, isScanning: false, isSummary: false, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
    }

    // MARK: - postImage
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
        let barcode = "5449000011527"
        guard let productImage = ProductImage(barcode: barcode, image: image, type: .front) else { XCTFail("A non nil ProductImage is required for the test"); return }
        let success: () -> Void = { resultSuccessful = true }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successfull result") }
        stub(condition: isPath("/cgi/product_image_upload.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("POST_Image_200.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productApi.postImage(productImage, onSuccess: success, onError: error)

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
        let barcode = "5449000011527"
        guard let productImage = ProductImage(barcode: barcode, image: image, type: .front) else { XCTFail("A non nil ProductImage is required for the test"); return }
        let success: () -> Void = { XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isPath("/cgi/product_image_upload.pl")) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: networkDownErrorCode, userInfo: nil)
            return OHHTTPStubsResponse(error: notConnectedError)
        }

        // when
        productApi.postImage(productImage, onSuccess: success, onError: error)

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
        let barcode = "5449000011527"
        guard let productImage = ProductImage(barcode: barcode, image: image, type: .front) else { XCTFail("A non nil ProductImage is required for the test"); return }
        let success: () -> Void = { XCTFail("Expecting a failing result") }
        let error: (Error) -> Void = { error in result = error as NSError }
        stub(condition: isPath("/cgi/product_image_upload.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("POST_Image_400.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        // when
        productApi.postImage(productImage, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result!.code) == 1
        expect(result!.domain) == Errors.domain
    }

    // MARK: - postProduct
    func testPostProductShouldSucceed() {
        var resultSuccessful = false

        // given
        let product = Product()
        let success: () -> Void = { resultSuccessful = true }
        let error: (Error) -> Void = { _ in XCTFail("Expecting a successful result") }
        stub(condition: isPath("/cgi/product_jqm2.pl")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("POST_Product_200.json", type(of: self))!,
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
        stub(condition: isPath("/cgi/product_jqm2.pl")) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: networkDownErrorCode, userInfo: nil)
            return OHHTTPStubsResponse(error: notConnectedError)
        }

        // when
        productApi.postProduct(product, onSuccess: success, onError: error)

        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.code) == networkDownErrorCode
    }

    // MARK: - logIn
    func testLogin() {
        var resultSuccessful = false
        let username = "test_user"
        let password = "test_password"
        let success: () -> Void = { resultSuccessful = true }
        let error: (Error) -> Void = { _ in XCTFail("Expected a successful result") }
        stub(condition: isPath("/cgi/session.pl")) { _ in
            return OHHTTPStubsResponse(
                data: "<html>Logged in just fine</html>".data(using: .utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "application/html"])
        }

        productApi.logIn(username: username, password: password, onSuccess: success, onError: error)

        expect(resultSuccessful).toEventually(beTrue(), timeout: 10)
    }

    func testLoginShouldReturnErrorWhenCredentialsAreWrong() {
        var result: Error?
        let username = "test_user"
        let password = "test_password"
        let success: () -> Void = { XCTFail("Expected a failing result") }
        let error: (Error) -> Void = { error in result = error }
        stub(condition: isPath("/cgi/session.pl")) { _ in
            return OHHTTPStubsResponse(
                data: "<html>Incorrect user name or password.</html>".data(using: .utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "application/html"])
        }

        productApi.logIn(username: username, password: password, onSuccess: success, onError: error)

        expect((result as NSError?)?.code).toEventually(equal(Errors.codes.wrongCredentials.rawValue), timeout: 10)
    }

    func testLoginShouldReturnErrorWhenServerReturnsError() {
        var result: Error?
        let username = "test_user"
        let password = "test_password"
        let success: () -> Void = { XCTFail("Expected a failing result") }
        let error: (Error) -> Void = { error in result = error }
        stub(condition: isPath("/cgi/session.pl")) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: networkDownErrorCode, userInfo: nil)
            return OHHTTPStubsResponse(error: notConnectedError)
        }

        productApi.logIn(username: username, password: password, onSuccess: success, onError: error)

        expect((result as NSError?)?.code).toEventually(equal(networkDownErrorCode), timeout: 10)
    }
}
