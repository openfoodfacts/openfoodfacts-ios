//
//  FormTableViewController.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 01/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import XLPagerTabStrip

class FormTableViewControllerTests: XCTestCase {
    var viewController: FormTableViewController!
    var productApi: ProductServiceMock!
    var form: Form!
    let firstRowValue = "abc"
    let secondRowValue = 123
    let title = "title"

    override func setUp() {
        let rows = [FormRow(value: firstRowValue, cellType: HostedViewCell.self),
                    FormRow(value: secondRowValue, cellType: NutritionLevelsTableViewCell.self)]
        form = Form(title: title, rows: rows)
        productApi = ProductServiceMock()
        viewController = FormTableViewController(with: form, productApi: productApi)
        UIApplication.shared.keyWindow!.rootViewController = viewController
        expect(self.viewController.view).toNot(beNil())
    }

    // MARK: - viewDidLoad
    func testViewDidLoad() {
        viewController.viewDidLoad()

        expect(self.viewController.tableView.alwaysBounceVertical).to(beFalse())
        expect(self.viewController.tableView.tableFooterView).notTo(beNil())
        expect(self.viewController.tableView.rowHeight).to(equal(UITableViewAutomaticDimension))
        expect(self.viewController.tableView.allowsSelection).to(beFalse())
        expect(self.viewController.tableView.cellLayoutMarginsFollowReadableWidth).to(beFalse())
        expect(self.viewController.tableView.dequeueReusableCell(withIdentifier: HostedViewCell.identifier)).notTo(beNil())
        expect(self.viewController.tableView.dequeueReusableCell(withIdentifier: NutritionLevelsTableViewCell.identifier)).notTo(beNil())
    }

    // MARK: - getCell
    func testGetCell() {
        let row = viewController.form.rows[0]

        let result = viewController.getCell(for: row)

        expect(result is HostedViewCell).to(beTrue())
    }

    // MARK: - numberOfSections
    func testNumberOfSections() {
        let result = viewController.numberOfSections(in: viewController.tableView)

        expect(result).to(equal(1))
    }

    // MARK: - numberOfRowsInSection
    func testNumberOfRowsInSection() {
        let section = 0

        let result = viewController.tableView(viewController.tableView, numberOfRowsInSection: section)

        expect(result).to(equal(form.rows.count))
    }

    // MARK: - cellForRowAt
    func testCellForRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)

        let cell = viewController.tableView(viewController.tableView, cellForRowAt: indexPath)

        expect(cell is HostedViewCell).to(beTrue())
    }

    // MARK: - estimatedHeightForRowAt
    func testEstimatedHeightForRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)

        let height = viewController.tableView(viewController.tableView, estimatedHeightForRowAt: indexPath)

        expect(height).to(equal(HostedViewCell.estimatedHeight))
    }

    // MARK: - shouldShowMenuForRowAt
    func testShouldShowMenuForRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)

        let result = viewController.tableView(viewController.tableView, shouldShowMenuForRowAt: indexPath)

        expect(result).to(beFalse())
    }

    // MARK: - canPerformAction
    func testCanPerformActionWhenSelectorIsCopy() {
        let selector = #selector(FormTableViewController.copy(_:))
        let indexPath = IndexPath(row: 0, section: 0)

        let result = viewController.tableView(viewController.tableView, canPerformAction: selector, forRowAt: indexPath, withSender: nil)

        expect(result).to(beTrue())
    }

    func testCanPerformActionWhenSelectorIsNotCopy() {
        let selector = #selector(FormTableViewController.paste(_:))
        let indexPath = IndexPath(row: 0, section: 0)

        let result = viewController.tableView(viewController.tableView, canPerformAction: selector, forRowAt: indexPath, withSender: nil)

        expect(result).to(beFalse())
    }

    // MARK: - performAction
    func testPerformActionShouldCopyValueToPasteboard() {
        let selector = #selector(FormTableViewController.paste(_:))
        let indexPath = IndexPath(row: 0, section: 0)

        viewController.tableView(viewController.tableView, performAction: selector, forRowAt: indexPath, withSender: nil)

        expect(UIPasteboard.general.string).to(equal(firstRowValue))
        expect(UIMenuController.shared.isMenuVisible).to(beFalse())
    }

    func testPerformActionShouldNotCopyValueToPasteboardWhenValueIsNotString() {
        let pasteboardPreviousValue = UIPasteboard.general.string
        let selector = #selector(FormTableViewController.paste(_:))
        let indexPath = IndexPath(row: 1, section: 0)

        viewController.tableView(viewController.tableView, performAction: selector, forRowAt: indexPath, withSender: nil)

        expect(UIPasteboard.general.string).to(equal(pasteboardPreviousValue))
        expect(UIMenuController.shared.isMenuVisible).to(beFalse())
    }

    // MARK: - indicatorInfo
    func testIndicatorInfo() {
        let pagerTabStripViewController = PagerTabStripViewController()

        let result = viewController.indicatorInfo(for: pagerTabStripViewController)

        expect(result.title).to(equal(title))
    }

    // MARK: - cellSizeDidChange
    func testCellSizeDidChange() {
        viewController.cellSizeDidChange()
    }
}
