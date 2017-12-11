//
//  IngredientsFormTableViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 26/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

class NutritionTableFormTableViewControllerTests: XCTestCase {
    var viewController: NutritionTableFormTableViewController!
    var productApi: ProductServiceMock!
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

        productApi = ProductServiceMock()
        form = Form(title: "", rows: [headerFormRow, infoFormRow])
        viewController = NutritionTableFormTableViewController(with: form, productApi: productApi)
    }

    // MARK: - Init
    func testInitWithFormAndProductApi() {
        let vc = SummaryFormTableViewController(with: form, productApi: productApi)

        expect(vc).notTo(beNil())
    }

    // MARK: - getCell
    func testGetCellCreatesHeaderRowWhenTypeIsHostedCell() {
        let cell = viewController.getCell(for: headerFormRow)

        expect(self.viewController.nutritionTableHeaderCellController).notTo(beNil())
        expect(self.viewController.childViewControllers[0]).to(equal(self.viewController.nutritionTableHeaderCellController))
        expect(cell is HostedViewCell).to(beTrue())
    }

    func testGetCellCreatesCellUsingSuperclassMethod() {
        let cell = viewController.getCell(for: infoFormRow)

        expect(self.viewController.nutritionTableHeaderCellController).to(beNil())
        expect(self.viewController.childViewControllers.count).to(equal(0))
        expect(cell is InfoRowTableViewCell).to(beTrue())
    }

    // MARK: - willDisplay
    func testWillDisplayAddsHeaderCellControllerAsChildVC() {
        let nutritionTableHeaderCellController = NutritionTableHeaderCellController()
        viewController.nutritionTableHeaderCellController = nutritionTableHeaderCellController

        viewController.tableView(self.viewController.tableView, willDisplay: HostedViewCell(), forRowAt: IndexPath(row: 0, section: 0))

        expect(self.viewController.childViewControllers[0]).to(equal(nutritionTableHeaderCellController))
    }

    // MARK: - didEndDisplaying
    func testDidEndDisplayingRemovesHeaderControllerFromVC() {
        let nutritionTableHeaderCellController = NutritionTableHeaderCellController(with: Product(), productApi: productApi)
        viewController.nutritionTableHeaderCellController = nutritionTableHeaderCellController
        viewController.addChildViewController(nutritionTableHeaderCellController)
        nutritionTableHeaderCellController.didMove(toParentViewController: viewController)
        viewController.view.addSubview(nutritionTableHeaderCellController.view)

        viewController.tableView(self.viewController.tableView, didEndDisplaying: HostedViewCell(), forRowAt: IndexPath(row: 0, section: 0))

        expect(nutritionTableHeaderCellController.view.superview).to(beNil())
        expect(self.viewController.childViewControllers.count).to(equal(0))
    }
}
