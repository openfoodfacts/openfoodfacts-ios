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
    var mockDataManager: DataManagerMock!
    let barcode = "123456789"
    var cameraController: CameraControllerMock!
    var notificationBannerEventMap: [String: [NotificationEventType]]!

    override func setUp() {
        super.setUp()

        mockDataManager = DataManagerMock()
        cameraController = CameraControllerMock()
        notificationBannerEventMap = [String: [NotificationEventType]]()

        viewController = TakePictureViewController()
        viewController.dataManager = mockDataManager
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
        let uploadingBannerTitle = "product-add.uploading-image-banner.title".localized
        let imageUploadSuccessBannerTitle = "product-add.image-upload-success-banner.title".localized

        viewController.didGetImage(image: testImage)

        expect(self.notificationBannerEventMap[uploadingBannerTitle]).toEventually(contain([.willAppear, .didAppear, .willDisappear, .didDisappear]))
        expect(self.notificationBannerEventMap[imageUploadSuccessBannerTitle]).toEventually(contain([.willAppear, .didAppear]), timeout: 10, pollInterval: 0.2)
        XCTAssertNotNil(mockDataManager.productImage)
    }

    func testDidGetImageErrorHandlerWhenPostingImage() {
        viewController.barcode = "111111111"
        let testImage = TestHelper.sharedInstance.getTestImage()
        let uploadingBannerTitle = "product-add.uploading-image-banner.title".localized
        let imageUploadErrorBannerTitle = "product-add.image-upload-error-banner.title".localized

        viewController.didGetImage(image: testImage)

        expect(self.notificationBannerEventMap[uploadingBannerTitle]).toEventually(contain([.willAppear, .didAppear, .willDisappear, .didDisappear]), timeout: 10)
        expect(self.notificationBannerEventMap[imageUploadErrorBannerTitle]).toEventually(contain([.willAppear, .didAppear]), timeout: 10)
        XCTAssertNotNil(mockDataManager.productImage)
    }

    func testDidGetImageDoesNotCallDataManagerWhenImageCanNotBeSaved() {
        viewController.barcode = "111111111"

        viewController.didGetImage(image: UIImage())

        expect(self.mockDataManager.postImageCalled).to(beFalse())
        expect(self.viewController.uploadingImageErrorBanner.isHidden).to(beFalse())
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
