//
//  TakePictureViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 14/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
import NotificationBanner
@testable import OpenFoodFacts
import Nimble

class TakePictureViewControllerTests: XCTestCase {
    var viewController: TakePictureViewController!
    var mockProductApi: ProductServiceMock!
    let barcode = "123456789"
    var cameraController: CameraControllerMock!
    var notificationBannerEventMap: [String: [NotificationEventType]]!

    override func setUp() {
        super.setUp()

        mockProductApi = ProductServiceMock()
        cameraController = CameraControllerMock()
        notificationBannerEventMap = [String: [NotificationEventType]]()

        viewController = TakePictureViewController()
        viewController.productApi = mockProductApi
        viewController.barcode = barcode
        viewController.cameraController = cameraController
        viewController.uploadingImageBanner.delegate = self
        viewController.uploadingImageErrorBanner.delegate = self
        viewController.uploadingImageSuccessBanner.delegate = self
        viewController.productAddSuccessBanner.delegate = self
    }

    func testDidTapTakePictureButtonShowsCameraController() {
        viewController.didTapTakePictureButton(UIButton())
        XCTAssertTrue(cameraController.isShown)
    }

    func testDidGetImageSuccessHandlerWhenPostingImage() {
        let testImage = TestHelper.sharedInstance.getTestImage()
        let uploadingBannerTitle = NSLocalizedString("product-add.uploading-image-banner.title", comment: "")
        let imageUploadSuccessBannerTitle = NSLocalizedString("product-add.image-upload-success-banner.title", comment: "")

        viewController.didGetImage(image: testImage)

        expect(self.notificationBannerEventMap[uploadingBannerTitle]).toEventually(contain([.willAppear, .didAppear, .willDisappear, .didDisappear]))
        expect(self.notificationBannerEventMap[imageUploadSuccessBannerTitle]).toEventually(contain([.willAppear, .didAppear]), timeout: 10, pollInterval: 0.2)
        XCTAssertNotNil(mockProductApi.productImage)
    }

    func testDidGetImageErrorHandlerWhenPostingImage() {
        viewController.barcode = "111111111"
        let testImage = TestHelper.sharedInstance.getTestImage()
        let uploadingBannerTitle = NSLocalizedString("product-add.uploading-image-banner.title", comment: "")
        let imageUploadErrorBannerTitle = NSLocalizedString("product-add.image-upload-error-banner.title", comment: "")

        viewController.didGetImage(image: testImage)

        expect(self.notificationBannerEventMap[uploadingBannerTitle]).toEventually(contain([.willAppear, .didAppear, .willDisappear, .didDisappear]), timeout: 10)
        expect(self.notificationBannerEventMap[imageUploadErrorBannerTitle]).toEventually(contain([.willAppear, .didAppear]), timeout: 10)
        XCTAssertNotNil(mockProductApi.productImage)
    }

    class CameraControllerMock: CameraController {
        var isShown = false
        weak var delegate: CameraControllerDelegate?

        func show() {
            isShown = true
        }
    }
}

extension TakePictureViewControllerTests: NotificationBannerDelegate {
    enum NotificationEventType {
        case willAppear, didAppear, willDisappear, didDisappear
    }

    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        addEventFor(title: banner.titleLabel?.text, event: .willAppear)
    }

    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        addEventFor(title: banner.titleLabel?.text, event: .didAppear)
    }

    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        addEventFor(title: banner.titleLabel?.text, event: .willDisappear)
    }

    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        addEventFor(title: banner.titleLabel?.text, event: .didDisappear)
    }

    private func addEventFor(title: String!, event: NotificationEventType) {
        if notificationBannerEventMap[title] == nil {
            notificationBannerEventMap[title] = [NotificationEventType]()
        }
        notificationBannerEventMap[title]!.append(event)
    }
}
