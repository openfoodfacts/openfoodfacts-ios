//
//  ExportHelperSpec.swift
//  OpenFoodFacts
//
//  Created by Mykola Aleschenko on 4/20/20.
//

@testable import OpenFoodFacts
import Quick
import Nimble

class ExportHelperSpec: QuickSpec {
    override func spec() {
        describe("exportHistory()") {
            it("exports history to CSV") {
                let historyItem = HistoryItem()
                historyItem.barcode = "111"
                historyItem.timestamp = Date()
                historyItem.brand = "Test Brand"

                let exportedFile = ExportHelper().exportItemsToCSV(objects: [historyItem])
                expect(exportedFile).notTo(beNil())
            }
        }
    }
}
