//
//  DataManagerMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 11/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts

class DataManagerMock: DataManagerProtocol {
    func getHistory() -> [Age: [HistoryItem]] {
        return [Age: [HistoryItem]]()
    }

    func addHistoryItem(_ product: Product) {
    }

    func clearHistory() {
    }
}
