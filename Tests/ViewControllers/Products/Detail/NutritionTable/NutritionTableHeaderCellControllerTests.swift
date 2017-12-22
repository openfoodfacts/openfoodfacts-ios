//
//  NutritionTableHeaderCellControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 30/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import OHHTTPStubs
import ImageViewer
import Kingfisher

class NutritionTableHeaderCellControllerTests: XCTestCase {
    var viewController: NutritionTableHeaderCellController!
    var dataManager: DataManagerMock!

    override func setUp() {
        dataManager = DataManagerMock()

        viewController = NutritionTableHeaderCellController(with: Product(), dataManager: dataManager)

        UIApplication.shared.keyWindow!.rootViewController = viewController

        expect(self.viewController.view).toNot(beNil())
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        super.tearDown()
    }

    // MARK: - viewDidLoad
    func testViewDidLoadWhenProductHasImageUrl() {
        let nutritionTableImage = "http://images.openfoodfacts.org/nutrition_table.jpg"
        let delegate = FormTableViewControllerDelegateMock()
        viewController.product.nutritionTableImage = nutritionTableImage
        viewController.delegate = delegate
        stub(condition: isMethodGET() && isAbsoluteURLString(nutritionTableImage)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test_image.jpg", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "image/jpeg"]
            )
        }

        viewController.viewDidLoad()

        expect(delegate.didCellSizeChange).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.nutritionTableImage.image).toNotEventually(beNil(), timeout: 10)
        expect(self.viewController.imageHeightConstraint?.constant).toEventually(equal(self.viewController.nutritionTableImage.image?.size.height))
        expect(self.viewController.nutritionTableImage.isUserInteractionEnabled).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.nutritionTableImage.gestureRecognizers![0] is UITapGestureRecognizer).toEventually(beTrue(), timeout: 10)
        expect(self.viewController.callToActionView.isHidden).to(beTrue())
        expect(self.viewController.addNewPictureButton.isHidden).to(beFalse())
    }

    func testViewDidLoadWhenImageHeightLargerThan130() {
        let nutritionTableImage = "http://images.openfoodfacts.org/big_nutrition_table.jpg"
        let newSize = CGSize(width: 1, height: 150)
        let image = UIImage()
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        viewController.product.nutritionTableImage = nutritionTableImage
        stub(condition: isMethodGET() && isAbsoluteURLString(nutritionTableImage)) { _ in
            return OHHTTPStubsResponse(
                data: UIImageJPEGRepresentation(newImage, 1.0)!,
                statusCode: 200,
                headers: ["Content-Type": "image/jpeg"]
            )
        }

        viewController.viewDidLoad()

        expect(self.viewController.imageHeightConstraint?.constant).toEventually(equal(130))
    }

    func testViewDidLoadWhenProductDoesNotHaveImageUrl() {
        viewController.viewDidLoad()

        expect(self.viewController.nutritionTableImage.isHidden).to(beTrue())
        expect(self.viewController.callToActionView.isHidden).to(beFalse())
        expect(self.viewController.callToActionView.textLabel.text).to(equal("call-to-action.nutrition".localized))
        expect(self.viewController.callToActionView.gestureRecognizers![0] is UITapGestureRecognizer).to(beTrue())
        expect(self.viewController.addNewPictureButton.isHidden).to(beTrue())
    }

    func testViewDidLoadShouldShowServiceSizeLabelWhenServingSizeValuePresent() {
        let servingSize = "15 g"
        viewController.product.servingSize = servingSize

        viewController.viewDidLoad()

        expect(self.viewController.servingSizeLabel.text).to(equal("\("product-detail.nutrition-table.for-serving".localized): \(servingSize)"))
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
