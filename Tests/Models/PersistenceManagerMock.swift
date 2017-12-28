//
//  PersistenceManagerMock.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts

class PersistenceManagerMock: PersistenceManagerProtocol {

    var getHistoryCalled = false
    var history: [HistoryItem]?
    var addHistoryItemCalled = false
    var product: Product?
    var clearHistoryCalled = false
    var addPendingUploadItemCalled = false
    var productImage: ProductImage?
    var getItemsPendingUploadCalled = false

    var getItemPendingUploadCalled = false
    var getItemPendingUploadBarcode: String?
    var getItemPendingUploadPendingUploadItem: PendingUploadItem?

    // MARK: - Search history

    func getHistory() -> [HistoryItem] {
        getHistoryCalled = true
        return history ?? [HistoryItem]()
    }

    func addHistoryItem(_ product: Product) {
        addHistoryItemCalled = true
        self.product = product
    }

    func clearHistory() {
        clearHistoryCalled = true
    }

    // MARK: - Products pending upload

    func addPendingUploadItem(_ product: Product) {
        addPendingUploadItemCalled = true
        self.product = product
    }

    func addPendingUploadItem(_ productImage: ProductImage) {
        addPendingUploadItemCalled = true
        self.productImage = productImage
    }

    func getItemsPendingUpload() -> [PendingUploadItem] {
        getItemsPendingUploadCalled = true
        return [PendingUploadItem]()
    }

    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem? {
        getItemPendingUploadCalled = true
        getItemPendingUploadBarcode = barcode
        return getItemPendingUploadPendingUploadItem
    }
}
