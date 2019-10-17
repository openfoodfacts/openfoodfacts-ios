//
//  SummaryFormTableViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 25/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

class SummaryFormTableViewControllerTests: XCTestCase {
    var viewController: SummaryFormTableViewController!
    var dataManager: DataManagerMock!
    var headerFormRow: FormRow!
    var infoFormRow: FormRow!
    var form: Form!

    override func setUp() {
        let label = "label"
        let product = Product()
        let cellType = HostedViewCell.self
        let isCopiable = false
        headerFormRow = FormRow(label: label, value: product, cellType: cellType, isCopiable: isCopiable)
        infoFormRow = FormRow(value: product, cellType: InfoRowTableViewCell.self)

        dataManager = DataManagerMock()
        form = Form(title: "", rows: [headerFormRow, infoFormRow])
        viewController = SummaryFormTableViewController(with: form, dataManager: dataManager)
    }

    // MARK: - Init
    func testInitWithFormAndProductApi() {
        let summaryFormTableVC = SummaryFormTableViewController(with: form, dataManager: dataManager)

        expect(summaryFormTableVC).notTo(beNil())
    }

    // MARK: - getCell
    func skiptestGetCellCreatesHeaderRowWhenTypeIsHostedCell() {
        let cell = viewController.getCell(for: headerFormRow)

        expect(self.viewController.summaryHeaderCellController).notTo(beNil())
        expect(self.viewController.children[0]).to(equal(self.viewController.summaryHeaderCellController))
        expect(cell is HostedViewCell).to(beTrue())
    }

    func testGetCellCreatesCellUsingSuperclassMethod() {
        let cell = viewController.getCell(for: infoFormRow)

        expect(self.viewController.summaryHeaderCellController).to(beNil())
        expect(self.viewController.children.count).to(equal(0))
        expect(cell is InfoRowTableViewCell).to(beTrue())
    }

    // MARK: - willDisplay
    func skiptestWillDisplayAddsHeaderCellControllerAsChildVC() {
        let summaryHeaderCellController = SummaryHeaderCellController()
        viewController.summaryHeaderCellController = summaryHeaderCellController

        viewController.tableView(self.viewController.tableView, willDisplay: HostedViewCell(), forRowAt: IndexPath(row: 0, section: 0))

        expect(self.viewController.children[0]).to(equal(summaryHeaderCellController))
    }

    // MARK: - didEndDisplaying
    func skiptestDidEndDisplayingRemovesHeaderControllerFromVC() {
        let summaryHeaderCellController = SummaryHeaderCellController(with: Product(), dataManager: dataManager, hideSummary: false)
        viewController.summaryHeaderCellController = summaryHeaderCellController
        viewController.addChild(summaryHeaderCellController)
        summaryHeaderCellController.didMove(toParent: viewController)
        viewController.view.addSubview(summaryHeaderCellController.view)

        viewController.tableView(self.viewController.tableView, didEndDisplaying: HostedViewCell(), forRowAt: IndexPath(row: 0, section: 0))

        expect(summaryHeaderCellController.view.superview).to(beNil())
        expect(self.viewController.children.count).to(equal(0))
    }
}
