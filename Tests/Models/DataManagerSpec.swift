//
//  DataManagerSpec.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 18/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble
import RealmSwift

// swiftlint:disable force_try
// swiftlint:disable function_body_length
class DataManagerSpec: QuickSpec {
    override func spec() {
        var dataManager: DataManagerProtocol!
        var realm: Realm!

        beforeEach {
            Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
            realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            dataManager = DataManager()
        }

        describe("getHistory()") {
            beforeEach {
                let historyItem1 = HistoryItem()
                historyItem1.barcode = "1"
                historyItem1.timestamp = Date()
                let historyItem2 = HistoryItem()
                historyItem2.barcode = "2"
                historyItem2.timestamp = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24 * 28)
                let historyItem3 = HistoryItem()
                historyItem3.barcode = "3"
                historyItem3.timestamp = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24 * 29)
                try! realm.write {
                    realm.add(historyItem1)
                    realm.add(historyItem2)
                    realm.add(historyItem3)
                }
            }

            it("returns a dictionary of history items by age with items ordered by most recent timestmap") {
                let result = dataManager.getHistory()

                expect(result[.last24h]![0].barcode).to(equal("1"))
                expect(result[.fewWeeks]![0].barcode).to(equal("2"))
                expect(result[.fewWeeks]![1].barcode).to(equal("3"))
            }
        }

        describe("addHistoryItem()") {
            it("saves a new HistoryItem") {
                var product = Product()
                product.barcode = "1"
                product.brands = ["Brand"]

                dataManager.addHistoryItem(product)

                expect(realm.objects(HistoryItem.self).count).toEventually(equal(1))
                expect(realm.objects(HistoryItem.self).first!.barcode).to(equal("1"))
            }

            it("does not save a HistoryItem that has no barcode") {
                var product = Product()
                product.brands = ["Brand"]

                dataManager.addHistoryItem(product)

                expect(realm.objects(HistoryItem.self).count).toEventually(equal(0))
            }
        }

        describe("clearHistory()") {
            it("deletes all HistoryItem") {
                try! realm.write {
                    let item = HistoryItem()
                    item.barcode = "1"
                    realm.add(item)
                }

                dataManager.clearHistory()

                expect(realm.objects(HistoryItem.self).count).toEventually(equal(0))
            }
        }
    }
}
