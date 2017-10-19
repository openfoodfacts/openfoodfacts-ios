//
//  IngredientsHeaderCellControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 29/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import OHHTTPStubs
import ImageViewer
import Kingfisher

class IngredientsHeaderCellControllerTests: XCTestCase {
    var viewController: IngredientsHeaderCellController!
    var productApi: ProductServiceMock!

    override func setUp() {
        productApi = ProductServiceMock()

        viewController = IngredientsHeaderCellController(with: Product(), productApi: productApi)

        UIApplication.shared.keyWindow!.rootViewController = viewController

        expect(self.viewController.view).toNot(beNil())
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        ImageCache.default.clearDiskCache(completion: nil)
        super.tearDown()
    }

    // MARK: - viewDidLoad
    func testViewDidLoadWhenProductHasImageUrl() {
        let ingredientsImageUrl = "http://images.openfoodfacts.org/ingredients.jpg"
        let delegate = FormTableViewControllerDelegateMock()
        viewController.product.ingredientsImageUrl = ingredientsImageUrl
        viewController.delegate = delegate
        stub(condition: isMethodGET() && isAbsoluteURLString(ingredientsImageUrl)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test_image.jpg", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "image/jpeg"]
            )
        }

        viewController.viewDidLoad()

        expect(delegate.didCellSizeChange).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.ingredients.image).toNotEventually(beNil(), timeout: 10)
        expect(self.viewController.ingredients.isUserInteractionEnabled).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.ingredients.gestureRecognizers![0] is UITapGestureRecognizer).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.callToActionView.isHidden).to(beTrue())
        expect(self.viewController.addNewPictureButton.isHidden).to(beFalse())
    }

    func testViewDidLoadWhenProductDoesNotHaveImageUrl() {
        viewController.viewDidLoad()

        expect(self.viewController.ingredients.isHidden).to(beTrue())
        expect(self.viewController.callToActionView.isHidden).to(beFalse())
        expect(self.viewController.callToActionView.textLabel.text).to(equal(NSLocalizedString("call-to-action.ingredients", comment: "")))
        expect(self.viewController.callToActionView.gestureRecognizers![0] is UITapGestureRecognizer).to(beTrue())
        expect(self.viewController.addNewPictureButton.isHidden).to(beTrue())
    }

    // MARK: - didTapProductImage
    func testDidTapProductImage() {
        let recognizer = UITapGestureRecognizer(target: nil, action: nil)
        let imageView = UIImageView()
        imageView.addGestureRecognizer(recognizer)

        viewController.didTapProductImage(recognizer)

        expect(self.viewController.presentedViewController is ImageViewer).to(beTrue())
    }

    private class FormTableViewControllerDelegateMock: FormTableViewControllerDelegate {
        var didCellSizeChange = false

        func cellSizeDidChange() {
            didCellSizeChange = true
        }
    }
}
