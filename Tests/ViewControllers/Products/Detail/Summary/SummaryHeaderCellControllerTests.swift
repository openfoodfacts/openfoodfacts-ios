//
//  SummaryHeaderCellControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 26/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import OHHTTPStubs
import ImageViewer

class SummaryHeaderCellControllerTests: XCTestCase {
    var viewController: SummaryHeaderCellController!
    var dataManager: DataManagerMock!

    override func setUp() {
        dataManager = DataManagerMock()

        viewController = SummaryHeaderCellController(with: Product(), dataManager: dataManager)

        UIApplication.shared.keyWindow!.rootViewController = viewController

        expect(self.viewController.view).toNot(beNil())
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    // MARK: - viewDidLoad
    func testViewDidLoadWhenProductHasImageUrlAndNutriscoreAndProductName() {
        let frontImageUrl = "http://images.openfoodfacts.org/frontUrl.jpg"
        let productName = "a product"
        viewController.product.frontImageUrl = frontImageUrl
        viewController.product.nutriscore = "a"
        viewController.product.name = productName
        stub(condition: isMethodGET() && isAbsoluteURLString(frontImageUrl)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test_image.jpg", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "image/jpeg"]
            )
        }

        viewController.viewDidLoad()

        expect(self.viewController.productImage.image).toNotEventually(beNil(), timeout: 10)
        expect(self.viewController.productImage.isUserInteractionEnabled).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.productImage.gestureRecognizers![0] is UITapGestureRecognizer).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.callToActionView.isHidden).to(beTrue())
        expect(self.viewController.nutriscore.currentScore).to(equal(NutriScoreView.Score.A))
        expect(self.viewController.productName.text).to(equal(productName))
        expect(self.viewController.addNewPictureButton.isHidden).to(beFalse())
    }

    func testViewDidLoadWhenProductDoesNotHaveImageUrlAndNutriscoreAndProductName() {
        viewController.viewDidLoad()

        expect(self.viewController.productImage.isHidden).to(beTrue())
        expect(self.viewController.callToActionView.isHidden).to(beFalse())
        expect(self.viewController.callToActionView.textLabel.text).to(equal("call-to-action.summary".localized))
        expect(self.viewController.callToActionView.gestureRecognizers![0] is UITapGestureRecognizer).to(beTrue())
        expect(self.viewController.nutriscore.superview?.isHidden).to(beTrue())
        expect(self.viewController.productName.isHidden).to(beTrue())
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
}
