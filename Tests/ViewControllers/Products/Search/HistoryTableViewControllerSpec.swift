//
//  HistoryTableViewControllerSpec.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

// swiftlint:disable function_body_length
class HistoryTableViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: HistoryTableViewController!
        var dataManager: DataManagerMock!
        var delegate: HistoryTableViewControllerDelegateMock!
        var tableView: UITableViewMock!

        beforeEach {
            tableView = UITableViewMock()
            delegate = HistoryTableViewControllerDelegateMock()
            dataManager = DataManagerMock()
            viewController = HistoryTableViewController.loadFromStoryboard(named: "Search") as HistoryTableViewController
            viewController.dataManager = dataManager
            viewController.delegate = delegate
        }

        describe("viewWillAppear()") {
            beforeEach {
                viewController.tableView = tableView
                viewController.viewWillAppear(false)
            }

            it("fetches history from DataManager") {
                expect(dataManager.getHistoryCalled).to(beTrue())
            }

            it("reloads table") {
                expect(tableView.reloadDataCalled).to(beTrue())
            }
        }

        describe("clearHistory()") {
            beforeEach {
                viewController.tableView = tableView
                viewController.items = [.last24h: [HistoryItem]()]
                viewController.clearHistory(UIBarButtonItem())
            }

            it("calls dataManager") {
                expect(dataManager.clearHistoryCalled).to(beTrue())
            }

            it("deletes all items") {
                expect(viewController.items).to(beEmpty())
            }

            it("reloads table") {
                expect(tableView.reloadDataCalled).to(beTrue())
            }
        }

        describe("numberOfSections()") {
            beforeEach {
                viewController.items = [.last24h: [HistoryItem](), .longTime: [HistoryItem]()]
            }

            it("returns number of keys in item plus one") {
                let result = viewController.numberOfSections(in: viewController.tableView)

                expect(result).to(equal(3))
            }
        }

        describe("numberOfRowsInSection()") {
            beforeEach {
                let item1 = HistoryItem()
                item1.barcode = "1"
                let item2 = HistoryItem()
                item2.barcode = "2"
                viewController.items = [.last24h: [item1, item2]]
            }

            it("returns one for privacy section") {
                let result = viewController.tableView(viewController.tableView, numberOfRowsInSection: 1)

                expect(result).to(equal(1))
            }

            it("returns two for last24h section") {
                let result = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)

                expect(result).to(equal(2))
            }
        }

        describe("cellForRowAt()") {
            it("returns privacy cell for first row in last section") {
                let indexPath = IndexPath(row: 0, section: 0)

                let result = viewController.tableView(viewController.tableView, cellForRowAt: indexPath)

                expect(result.reuseIdentifier).to(equal(HistoryCellId.privacy))
            }

            it("returns history item cell") {
                let item = HistoryItem()
                item.barcode = "1"
                viewController.items = [.last24h: [item]]
                let indexPath = IndexPath(row: 0, section: 0)

                let result = viewController.tableView(viewController.tableView, cellForRowAt: indexPath)

                expect(result.reuseIdentifier).to(equal(HistoryCellId.item))
                expect(result is HistoryItemCell).to(beTrue())
            }
        }

        describe("titleForHeaderInSection()") {
            beforeEach {
                viewController.items = [.last24h: [HistoryItem](), .fewDays: [HistoryItem](), .fewWeeks: [HistoryItem](), .fewMonths: [HistoryItem](), .longTime: [HistoryItem]()]
            }

            it("returns last24h title for last24h section") {
                let result = viewController.tableView(viewController.tableView, titleForHeaderInSection: 0)

                expect(result).to(equal("history.section-titles.last24h".localized))
            }

            it("returns fewDays title for fewDays section") {
                let result = viewController.tableView(viewController.tableView, titleForHeaderInSection: 1)

                expect(result).to(equal("history.section-titles.fewDays".localized))
            }

            it("returns fewWeeks title for fewWeeks section") {
                let result = viewController.tableView(viewController.tableView, titleForHeaderInSection: 2)

                expect(result).to(equal("history.section-titles.fewWeeks".localized))
            }

            it("returns fewMonths title for fewMonths section") {
                let result = viewController.tableView(viewController.tableView, titleForHeaderInSection: 3)

                expect(result).to(equal("history.section-titles.fewMonths".localized))
            }

            it("returns longTime title for longTime section") {
                let result = viewController.tableView(viewController.tableView, titleForHeaderInSection: 4)

                expect(result).to(equal("history.section-titles.longTime".localized))
            }

            it("returns nil for privacy section") {
                let result = viewController.tableView(viewController.tableView, titleForHeaderInSection: 5)

                expect(result).to(beNil())
            }
        }

        describe("didSelectRowAt()") {
            let item1 = HistoryItem()
            let item2 = HistoryItem()
            item2.barcode = "987654321"

            beforeEach {
                viewController.items = [.last24h: [item1, item2]]
            }

            it("does nothing when selected privacy cell") {
                let indexPath = IndexPath(row: 0, section: 1)

                viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)

                expect(delegate.showItemCalled).to(beFalse())
            }

            it("calls delegate when tapped on history item") {
                let indexPath = IndexPath(row: 0, section: 0)

                viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)

                expect(delegate.showItemCalled).to(beTrue())
                XCTAssertEqual(item1, delegate.showItem)
            }

            it("shows error when delegate calls onError") {
                let indexPath = IndexPath(row: 1, section: 0)

                viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)

                expect(delegate.showItemCalled).to(beTrue())
                expect(viewController.showDetailsBanner.isDisplaying).toEventually(beTrue())
            }
        }
    }
}

class HistoryTableViewControllerDelegateMock: HistoryTableViewControllerDelegate {
    var showItemCalled = false
    var showItem: HistoryItem?

    func showItem(_ item: HistoryItem, onError: @escaping () -> Void) {
        showItemCalled = true
        showItem = item

        if item.barcode == "987654321" {
            onError()
        }
    }
}

class UITableViewMock: UITableView {
    var reloadDataCalled = false

    override func reloadData() {
        reloadDataCalled = true
        super.reloadData()
    }
}
