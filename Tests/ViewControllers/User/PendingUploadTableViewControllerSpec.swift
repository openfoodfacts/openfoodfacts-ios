//
//  PendingUploadTableViewControllerSpec.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 01/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble
import SVProgressHUD

// swiftlint:disable function_body_length
class PendingUploadTableViewControllerSpec: QuickSpec {
    override func spec() {
        var dataManager: DataManagerMock?
        var viewController: PendingUploadTableViewController?
        var tableView: UITableViewMock?

        beforeEach {
            dataManager = DataManagerMock()
            viewController = PendingUploadTableViewController.loadFromStoryboard(named: .user) as PendingUploadTableViewController
            viewController?.dataManager = dataManager
        }

        describe("items") {
            beforeEach {
                tableView = UITableViewMock()
                viewController?.tableView = tableView

                let item = PendingUploadItem(barcode: "1")
                viewController?.items = [item]
            }

            it("reloads the table view after setting") {
                expect(tableView?.reloadDataCalled).to(beTrue())
            }
        }

        describe(".viewWillAppear") {
            beforeEach {
                viewController?.viewWillAppear(false)
            }

            it("reloads data") {
                expect(dataManager?.getItemsPendingUploadCalled).to(beTrue())
            }

            context("when data manager returns zero items") {
                beforeEach {
                    viewController?.uploadButton.isEnabled = true

                    viewController?.viewWillAppear(false)
                }

                it("disables upload button") {
                    expect(viewController?.uploadButton.isEnabled).to(beFalse())
                }
            }

            context("when data manager returns one or more items") {
                beforeEach {
                    let item = PendingUploadItem(barcode: "1")
                    dataManager?.items = [item]
                    viewController?.uploadButton.isEnabled = false

                    viewController?.viewWillAppear(false)
                }

                it("enables upload button") {
                    expect(viewController?.uploadButton.isEnabled).to(beTrue())
                }
            }
        }

        describe(".uploadButtonTapped") {
            context("when progress handler not called") {
                beforeEach {
                    viewController?.uploadButtonTapped(UIBarButtonItem())
                }

                it("calls data manager") {
                    expect(dataManager?.uploadPendingItemsCalled).to(beTrue())
                }

                it("displays HUD") {
                    expect(SVProgressHUD.isVisible()).toEventually(beTrue())
                }
            }

            context("when progress handler called while still processing items") {
                beforeEach {
                    dataManager?.progress = 0.5
                    viewController?.uploadButtonTapped(UIBarButtonItem())
                }

                it("displays HUD") {
                    expect(SVProgressHUD.isVisible()).toEventually(beTrue())
                }
            }

            context("when progress handler called after processing items") {
                beforeEach {
                    dataManager?.progress = 1.0
                    viewController?.uploadButtonTapped(UIBarButtonItem())
                }

                it("dismisses HUD") {
                    expect(SVProgressHUD.isVisible()).toEventually(beFalse())
                }

                it("reloads table data") {
                    expect(dataManager?.getItemsPendingUploadCalled).to(beTrue())
                }
            }
        }

        describe(".numberOfSections") {
            var sections: Int?

            context("when items array is empty") {
                beforeEach {
                    sections = viewController?.numberOfSections(in: viewController!.tableView)
                }

                it("returns one section for info cell") {
                    expect(sections).to(equal(1))
                }
            }

            context("when items array has items") {
                beforeEach {
                    viewController?.items = self.getItemsArray()

                    sections = viewController?.numberOfSections(in: viewController!.tableView)
                }

                it("returns one section for items and one for info cell") {
                    expect(sections).to(equal(2))
                }
            }
        }

        describe(".numberOfRowsInSection") {
            var rows: Int?

            beforeEach {
                viewController?.items = self.getItemsArray()
            }

            describe("when requesting info section") {
                beforeEach {
                    rows = viewController?.tableView(viewController!.tableView, numberOfRowsInSection: 1)
                }

                it("returns 1 for info section") {
                    expect(rows).to(equal(1))
                }
            }

            describe("when requesting items section") {
                beforeEach {
                    rows = viewController?.tableView(viewController!.tableView, numberOfRowsInSection: 0)
                }

                it("returns the number of items") {
                    expect(rows).to(equal(self.getItemsArray().count))
                }
            }
        }

        describe(".cellForRowAt") {
            var cell: UITableViewCell?

            beforeEach {
                viewController?.items = self.getItemsArray()
            }

            describe("when requesting info cell") {
                beforeEach {
                    cell = viewController?.tableView(viewController!.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
                }

                it("returns info cell") {
                    expect(cell?.reuseIdentifier).to(equal(PendingUploadCellIds.info))
                }
            }

            describe("when requesting item cell") {
                beforeEach {
                    cell = viewController?.tableView(viewController!.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
                }

                it("returns info cell") {
                    expect(cell?.reuseIdentifier).to(equal(PendingUploadCellIds.item))
                    expect(cell is PendingUploadItemCell).to(beTrue())
                }
            }
        }
    }

    private func getItemsArray() -> [PendingUploadItem] {
        let item1 = PendingUploadItem(barcode: "1")
        let item2 = PendingUploadItem(barcode: "2")
        return [item1, item2]
    }
}
