//
//  ProductAddViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 23/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

// swiftlint:disable force_cast
class ProductAddViewControllerTests: XCTestCase {
    var viewController: ProductAddViewController!
    var navigationController: UINavigationControllerMock!
    var dataManager: DataManagerMock!

    private let barcode = "123456789"
    private let anotherBarcode = "987654321"
    private let quantity = "50"
    private let quantityUnit = "cl"
    private let brands = "Fanta"
    private let productName = "Fanta Orange"

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: Bundle.main)
        viewController = storyboard.instantiateInitialViewController() as! ProductAddViewController
        navigationController = UINavigationControllerMock(rootViewController: viewController)

        dataManager = DataManagerMock()
        viewController.dataManager = dataManager

        triggerViewLifecycle()
    }

    override func tearDown() {
        viewController = nil
        XCUIDevice.shared.orientation = .portrait
        super.tearDown()
    }

    // MARK: - Barcode didSet

    func testSettingBarcodeUpdatesProductBarcode() {
        viewController.barcode = anotherBarcode

        expect(self.viewController.product.barcode).to(equal(anotherBarcode))
    }

    // MARK: - viewWillAppear

    func testWhenAfterWillAppearBarcodeLabelIsUpdated() {
        viewController.barcode = barcode

        expect(self.viewController.barcodeLabel.text).to(equal(barcode))
    }

    func testFormIsFilledWhenPendingUploadItemExistsForTheBarcode() {
        let productName = "product_name"
        let brand = "Brand"
        let quantityValue = "33"
        let quantityUnit = "cl"
        let language = "de"
        let pendingUploadItem = PendingUploadItem(barcode: barcode)
        pendingUploadItem.productName = productName
        pendingUploadItem.brand = brand
        pendingUploadItem.quantityValue = quantityValue
        pendingUploadItem.quantityUnit = quantityUnit
        pendingUploadItem.language = language
        dataManager.pendingUploadItem = pendingUploadItem
        viewController.barcode = barcode

        viewController.viewWillAppear(false)

        expect(self.viewController.productNameField.text).to(equal(productName))
        expect(self.viewController.brandsField.text).to(equal(brand))
        expect(self.viewController.quantityField.text).to(equal(quantityValue))
        expect(self.viewController.languageField.text).to(equal(Locale.current.localizedString(forIdentifier: language)))
    }

    // MARK: - didTapSaveButton

    func testOnSaveButtonTapProductIsSent() {
        viewController.barcode = barcode
        viewController.productNameField.text = productName
        viewController.brandsField.text = brands
        viewController.quantityField.text = quantity
        viewController.quantityField.becomeFirstResponder()

        viewController.didTapSaveProductButton(UIButton())

        expect(self.viewController.quantityField.isFirstResponder).to(beFalse())
        expect(self.dataManager.product).toEventuallyNot(beNil())
        expect(self.dataManager.product.name).to(equal(productName))
        expect(self.dataManager.product.brands).to(equal([brands]))
        expect(self.dataManager.product.quantity).to(equal("\(quantity) \(quantityUnit)"))
        expect(self.dataManager.product.barcode).to(equal(barcode))
        expect(self.viewController.productAddSuccessBanner.isHidden).to(beFalse())
        expect(self.navigationController.didPopToRootViewController).to(beTrue())
    }

    func testOnSaveButtonTapErrorAlertIsShownWhenPostFails() {
        viewController.barcode = anotherBarcode

        viewController.didTapSaveProductButton(UIButton())

        expect(self.viewController.presentedViewController is UIAlertController).toEventually(beTrue())
        let alertController = self.viewController.presentedViewController as! UIAlertController
        expect(alertController.title).to(equal("product-add.save-error.title".localized))
        expect(alertController.message).to(equal("product-add.save-error.message".localized))
        expect(alertController.actions[0].title).to(equal("alert.action.ok".localized))
    }

    // MARK: - keyboardWillShow

    // Note: This test may fail in the simulator. To succeed the software keyboard needs to be activated.
    func testKeyboardWillShowShouldUpdateScrollViewInsetsWhenOrientationPortrait() {
        let width = CGFloat(375)
        let height = CGFloat(258)
        let rectSize = CGSize(width: width, height: height)
        let cgRect = CGRect(origin: CGPoint.zero, size: rectSize)
        let userInfo: [String: Any] = [UIKeyboardFrameEndUserInfoKey: cgRect as NSValue]
        let notification = Notification(name: .UIKeyboardWillShow, object: nil, userInfo: userInfo)
        viewController.quantityField.becomeFirstResponder()

        viewController.keyboardWillShow(notification: notification)

        expect(self.viewController.scrollView.contentInset.bottom).to(equal(height))
        expect(self.viewController.scrollView.scrollIndicatorInsets.bottom).to(equal(height))
        expect(self.viewController.scrollView.contentOffset).toEventuallyNot(equal(CGPoint.zero), timeout: 10)
    }

    func testKeyboardWillShowShouldUpdateScrollViewInsetsWhenOrientationLandscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
        let width = CGFloat(258)
        let height = CGFloat(375)
        let rectSize = CGSize(width: width, height: height)
        let cgRect = CGRect(origin: CGPoint.zero, size: rectSize)
        let userInfo: [String: Any] = [UIKeyboardFrameEndUserInfoKey: cgRect as NSValue]
        let notification = Notification(name: .UIKeyboardWillShow, object: nil, userInfo: userInfo)
        viewController.productNameField.becomeFirstResponder()

        viewController.keyboardWillShow(notification: notification)

        expect(self.viewController.scrollView.contentInset.bottom).to(equal(width))
        expect(self.viewController.scrollView.scrollIndicatorInsets.bottom).to(equal(width))
    }

    // MARK: - keyboardWillHide

    func testKeyboardWillHideShouldResetScrollViewInsets() {
        let notification = Notification(name: .UIKeyboardWillHide, object: nil, userInfo: nil)
        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 30)
        viewController.scrollView.contentInset = inset
        viewController.scrollView.scrollIndicatorInsets = inset

        viewController.keyboardWillHide(notification: notification)

        expect(self.viewController.scrollView.contentInset).to(equal(UIEdgeInsets.zero))
        expect(self.viewController.scrollView.scrollIndicatorInsets).to(equal(UIEdgeInsets.zero))
    }

    // MARK: - Helper functions
    private func triggerViewLifecycle() {
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        expect(self.navigationController.view).notTo(beNil())
        expect(self.viewController.view).notTo(beNil())
    }
}
