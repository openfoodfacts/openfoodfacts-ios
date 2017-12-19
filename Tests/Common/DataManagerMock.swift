//
//  DataManagerMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 11/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts

class DataManagerMock: DataManagerProtocol {
    var getHistoryCalled = false
    var historyToReturn: [Age: [HistoryItem]]?
    var addHistoyItemCalled = false
    var addHistoryItemProduct: Product?
    var clearHistoryCalled = false

    func getHistory() -> [Age: [HistoryItem]] {
        getHistoryCalled = true
        return historyToReturn ?? [Age: [HistoryItem]]()
    }

    func addHistoryItem(_ product: Product) {
        addHistoyItemCalled = true
        addHistoryItemProduct = product
    }

    func clearHistory() {
        clearHistoryCalled = true
    }
}
