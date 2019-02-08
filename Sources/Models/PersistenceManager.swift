//
//  PersistenceManager.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 21/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import Crashlytics
import UIKit

protocol PersistenceManagerProtocol {
    // Search history
    func getHistory() -> [HistoryItem]
    func addHistoryItem(_ product: Product)
    func clearHistory()

    // taxonomies
    func save(categories: [Category])
    func category(forCode: String) -> Category?

    func save(allergens: [Allergen])
    func allergen(forCode: String) -> Allergen?

    func save(additives: [Additive])
    func additive(forCode: String) -> Additive?

    // Products pending upload
    func addPendingUploadItem(_ product: Product)
    func addPendingUploadItem(_ productImage: ProductImage)
    func getItemsPendingUpload() -> [PendingUploadItem]
    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem?
    func deletePendingUploadItem(_ item: PendingUploadItem)
    func updatePendingUploadItem(_ item: PendingUploadItem)
}

class PersistenceManager: PersistenceManagerProtocol {

    fileprivate func saveOrUpdate(objects: [Object]) {
        let realm = getRealm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        do {
            try realm.write {
                realm.add(objects, update: true)
            }
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    // MARK: - Search history

    func getHistory() -> [HistoryItem] {
        let realm = getRealm()
        return Array(realm.objects(HistoryItem.self).sorted(byKeyPath: "timestamp", ascending: false))
    }

    func addHistoryItem(_ product: Product) {
        DispatchQueue.global(qos: .background).async {
            guard let barcode = product.barcode else { return }

            let realm = self.getRealm()

            do {
                let item = HistoryItem()

                item.barcode = barcode
                item.productName = product.name
                item.quantity = product.quantity
                item.imageUrl = product.imageUrl
                item.nutriscore = product.nutriscore
                item.novagroup = product.novaGroup
                item.timestamp = Date()

                if let brands = product.brands, !brands.isEmpty {
                    item.brand = brands[0]
                }

                try realm.write {
                    realm.add(item, update: true)
                }
            } catch let error as NSError {
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    func clearHistory() {
        DispatchQueue.global(qos: .background).async {
            let realm = self.getRealm()

            do {
                try realm.write {
                    realm.delete(realm.objects(HistoryItem.self))
                }
            } catch let error as NSError {
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    // MARK: - Taxonomies
    func save(categories: [Category]) {
        saveOrUpdate(objects: categories)
        log.info("Saved \(categories.count) categories in taxonomies database")
    }

    func category(forCode code: String) -> Category? {
        return getRealm().object(ofType: Category.self, forPrimaryKey: code)
    }

    func save(allergens: [Allergen]) {
        saveOrUpdate(objects: allergens)
        log.info("Saved \(allergens.count) allergens in taxonomies database")
    }

    func allergen(forCode code: String) -> Allergen? {
        return getRealm().object(ofType: Allergen.self, forPrimaryKey: code)
    }

    func save(additives: [Additive]) {
        saveOrUpdate(objects: additives)
        log.info("Saved \(additives.count) additives in taxonomies database")
    }

    func additive(forCode code: String) -> Additive? {
        return getRealm().object(ofType: Additive.self, forPrimaryKey: code)
    }

    // MARK: - Products pending upload

    func addPendingUploadItem(_ product: Product) {
        guard let barcode = product.barcode else { return }

        let item = getPendingUploadItem(forBarcode: barcode) ?? PendingUploadItem(barcode: barcode)
        item.productName = product.name
        item.quantityValue = product.quantityValue
        item.quantityUnit = product.quantityUnit

        if let brands = product.brands {
            item.brand = brands[0]
        }

        // Images are not saved here because everytime a picture is taken (in ProductAdd, for example),
        // DataManager gets called and it stores it already on the PendingUploadItem

        // Save in Realm
        let realm = getRealm()

        do {
            let realmItem = RealmPendingUploadItem().fromPendingUploadItem(item)
            try realm.write {
                realm.add(realmItem)
            }

            let count = getItemsPendingUpload().count
            NotificationCenter.default.post(name: .pendingUploadBadgeChange, object: nil, userInfo: [NotificationUserInfoKey.pendingUploadItemCount: count])
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    func addPendingUploadItem(_ productImage: ProductImage) {
        DispatchQueue.global(qos: .background).async {
            let realm = self.getRealm()
            let item = self.getPendingUploadItem(forBarcode: productImage.barcode) ?? PendingUploadItem(barcode: productImage.barcode)

            do {
                switch productImage.type {
                case .front:
                    item.frontImage = productImage
                case .ingredients:
                    item.ingredientsImage = productImage
                case .nutrition:
                    item.nutritionImage = productImage
                }

                let realmItem = RealmPendingUploadItem().fromPendingUploadItem(item)

                try realm.write {
                    realm.add(realmItem)
                }
            } catch let error as NSError {
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    func getItemsPendingUpload() -> [PendingUploadItem] {
        let realm = getRealm()
        return Array(realm.objects(RealmPendingUploadItem.self)).map { $0.toPendingUploadItem() }
    }

    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem? {
        let realm = getRealm()
        return realm.object(ofType: RealmPendingUploadItem.self, forPrimaryKey: barcode)?.toPendingUploadItem()
    }

    func deletePendingUploadItem(_ item: PendingUploadItem) {
        DispatchQueue.global(qos: .background).async {
            let realm = self.getRealm()
            do {
                guard let realmItem = realm.object(ofType: RealmPendingUploadItem.self, forPrimaryKey: item.barcode) else { return }
                try realm.write {
                    realm.delete(realmItem)
                }
            } catch let error as NSError {
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    func updatePendingUploadItem(_ item: PendingUploadItem) {
        DispatchQueue.global(qos: .background).async {
            let realm = self.getRealm()
            do {
                let realmItem = RealmPendingUploadItem().fromPendingUploadItem(item)
                try realm.write {
                    realm.add(realmItem, update: true)
                }
            } catch let error as NSError {
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    private func getPendingUploadItem(forBarcode barcode: String) -> PendingUploadItem? {
        let realm = getRealm()
        return realm.object(ofType: RealmPendingUploadItem.self, forPrimaryKey: barcode)?.toPendingUploadItem()
    }

    // MARK: - Private functions

    private func getRealm() -> Realm {
        do {
            return try Realm()
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
        fatalError("Could not get Realm instance")
    }
}
