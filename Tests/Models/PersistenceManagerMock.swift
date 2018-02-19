//
//  PersistenceManagerMock.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts

class PersistenceManagerMock: PersistenceManagerProtocol {

    // Common
    var product: Product?
    var pendingUploadItem: PendingUploadItem?

    // getHistory
    var getHistoryCalled = false
    var history: [HistoryItem]?

    // addHistoryItem
    var addHistoryItemCalled = false

    // clearHistory
    var clearHistoryCalled = false

    // addPendingUploadItem
    var addPendingUploadItemCalled = false
    var productImage: ProductImage?

    // getItemsPendingUpload
    var getItemsPendingUploadCalled = false
    var itemsPendingUpload: [PendingUploadItem]?

    // getItemPendingUpload
    var getItemPendingUploadCalled = false
    var getItemPendingUploadBarcode: String?
    var getItemPendingUploadPendingUploadItem: PendingUploadItem?

    // deletePendingUploadItem
    var deletePendingUploadItemCalled = false

    // updatePendingUploadItem
    var updatePendingUploadItemCalled = false

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
        return itemsPendingUpload ?? [PendingUploadItem]()
    }

    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem? {
        getItemPendingUploadCalled = true
        getItemPendingUploadBarcode = barcode
        return getItemPendingUploadPendingUploadItem
    }

    func deletePendingUploadItem(_ item: PendingUploadItem) {
        deletePendingUploadItemCalled = true
        pendingUploadItem = item
    }

    func updatePendingUploadItem(_ item: PendingUploadItem) {
        updatePendingUploadItemCalled = true
        pendingUploadItem = item
    }
}
