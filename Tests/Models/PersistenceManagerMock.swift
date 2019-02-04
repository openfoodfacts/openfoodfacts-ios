//
//  PersistenceManagerMock.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import RealmSwift

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

    fileprivate func realm() -> Realm {
        // swiftlint:disable:next force_try
        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "in-memory-test-realm",
                                                             schemaVersion: 1,
                                                             deleteRealmIfMigrationNeeded: true))
    }

    // MARK: - Taxonomies
    func objectSearch<T>(forQuery: String?, ofClass: T.Type) -> Results<T>? where T: Object {
        return realm().objects(T.self)
    }

    func save(nutriments: [Nutriment]) {
    }

    func nutriment(forCode: String) -> Nutriment? {
        return nil
    }

    func nutrimentSearch(query: String?) -> Results<Nutriment> {
        return realm().objects(Nutriment.self)
    }

    func categorySearch(query: String?) -> Results<Category> {
        return realm().objects(Category.self)
    }

    func save(categories: [Category]) {
    }

    func category(forCode: String) -> Category? {
        return nil
    }

    func save(allergens: [Allergen]) {
    }

    func allergen(forCode: String) -> Allergen? {
        return nil
    }

    func save(additives: [Additive]) {
    }

    func additive(forCode: String) -> Additive? {
        return nil
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
