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
    var productApi: ProductServiceMock!

    private let barcode = "123456789"
    private let anotherBarcode = "987654321"
    private let quantity = "50 cl"
    private let brands = "Fanta"
    private let productName = "Fanta Orange"

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: Bundle.main)
        viewController = storyboard.instantiateInitialViewController() as! ProductAddViewController
        navigationController = UINavigationControllerMock(rootViewController: viewController)

        productApi = ProductServiceMock()
        viewController.productApi = productApi

        UIApplication.shared.keyWindow!.rootViewController = navigationController

        expect(self.navigationController.view).notTo(beNil())
        expect(self.viewController.view).notTo(beNil())
    }

    override func tearDown() {
        viewController.activeField?.resignFirstResponder()
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

    // MARK: - didTapSaveButton

    func testOnSaveButtonTapProductIsSent() {
        viewController.barcode = barcode
        viewController.productNameField.text = productName
        viewController.brandsField.text = brands
        viewController.quantityField.text = quantity
        viewController.quantityField.becomeFirstResponder()

        viewController.didTapSaveButton(UIButton())

        expect(self.viewController.quantityField.isFirstResponder).to(beFalse())
        expect(self.productApi.product).toEventuallyNot(beNil())
        expect(self.productApi.product.name).to(equal(productName))
        expect(self.productApi.product.brands).to(equal([brands]))
        expect(self.productApi.product.quantity).to(equal(quantity))
        expect(self.productApi.product.barcode).to(equal(barcode))
        expect(self.viewController.productAddSuccessBanner.isHidden).to(beFalse())
        expect(self.navigationController.didPopToRootViewController).to(beTrue())
    }

    func testOnSaveButtonTapErrorAlertIsShownWhenPostFails() {
        viewController.barcode = anotherBarcode

        viewController.didTapSaveButton(UIButton())

        expect(self.viewController.presentedViewController is UIAlertController).toEventually(beTrue())
        let alertController = self.viewController.presentedViewController as! UIAlertController
        expect(alertController.title).to(equal(NSLocalizedString("product-add.save-error.title", comment: "")))
        expect(alertController.message).to(equal(NSLocalizedString("product-add.save-error.message", comment: "")))
        expect(alertController.actions[0].title).to(equal(NSLocalizedString("alert.action.ok", comment: "")))
    }

    // MARK: - keyboardWillShow

    // Note: This test may fail when the simulator is not configured to show the software keyboard.
    func testKeyboardWillShowShouldUpdateScrollViewInsetsWhenOrientationPortrait() {
        let width = CGFloat(375)
        let height = CGFloat(258)
        let rectSize = CGSize(width: width, height: height)
        let cgRect = CGRect(origin: CGPoint.zero, size: rectSize)
        let userInfo: [String: Any] = [UIKeyboardFrameEndUserInfoKey: cgRect as NSValue]
        let notification = Notification(name: .UIKeyboardWillShow, object: nil, userInfo: userInfo)
        viewController.quantityField.becomeFirstResponder()
        viewController.activeField = viewController.quantityField

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
        viewController.activeField = viewController.productNameField

        viewController.keyboardWillShow(notification: notification)

        expect(self.viewController.scrollView.contentInset.bottom).to(equal(width))
        expect(self.viewController.scrollView.scrollIndicatorInsets.bottom).to(equal(width))
    }

    func testKeyboardWillShowShouldDoNothingWhenKeyboardFrameUnknown() {
        let notification = Notification(name: .UIKeyboardWillShow, object: nil, userInfo: [:])

        viewController.keyboardWillShow(notification: notification)

        expect(self.viewController.contentInsetsBeforeKeyboard).to(equal(UIEdgeInsets.zero))
    }

    func testKeyboardWillShowShouldDoNothingWhenNoFieldIsActive() {
        let width = CGFloat(20)
        let height = CGFloat(15)
        let rectSize = CGSize(width: width, height: height)
        let cgRect = CGRect(origin: CGPoint.zero, size: rectSize)
        let userInfo: [String: Any] = [UIKeyboardFrameEndUserInfoKey: cgRect as NSValue]
        let notification = Notification(name: .UIKeyboardWillShow, object: nil, userInfo: userInfo)

        viewController.keyboardWillShow(notification: notification)

        expect(self.viewController.contentInsetsBeforeKeyboard).to(equal(UIEdgeInsets.zero))
    }

    // MARK: - keyboardWillHide

    func testKeyboardWillHideShouldResetScrollViewInsets() {
        let notification = Notification(name: .UIKeyboardWillHide, object: nil, userInfo: nil)
        viewController.contentInsetsBeforeKeyboard = UIEdgeInsets.zero
        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 30)
        viewController.scrollView.contentInset = inset
        viewController.scrollView.scrollIndicatorInsets = inset

        viewController.keyboardWillHide(notification: notification)

        expect(self.viewController.scrollView.contentInset).to(equal(UIEdgeInsets.zero))
        expect(self.viewController.scrollView.scrollIndicatorInsets).to(equal(UIEdgeInsets.zero))
    }

    // MARK: - textFieldDidBeginEditing

    func testTextFieldDidBeginEditingSetsActiveField() {
        viewController.textFieldDidBeginEditing(viewController.brandsField)

        expect(self.viewController.activeField).to(equal(viewController.brandsField))
    }

    // MARK: - textFieldDidEndEditing

    func testTextFieldDidEndEditingSetsActiveFieldToNil() {
        viewController.activeField = viewController.productNameField

        viewController.textFieldDidEndEditing(viewController.productNameField)

        expect(self.viewController.activeField).to(beNil())
    }
}
