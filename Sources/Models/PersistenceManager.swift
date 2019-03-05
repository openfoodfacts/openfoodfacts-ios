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
    func objectSearch<T: Object>(forQuery: String?, ofClass: T.Type) -> Results<T>?

    func save(categories: [Category])
    func category(forCode: String) -> Category?
    func categorySearch(query: String?) -> Results<Category>

    func save(allergens: [Allergen])
    func allergen(forCode: String) -> Allergen?

    func save(nutriments: [Nutriment])
    func nutriment(forCode: String) -> Nutriment?
    func nutrimentSearch(query: String?) -> Results<Nutriment>

    func save(additives: [Additive])
    func additive(forCode: String) -> Additive?

    // Offline
    func save(offlineProducts: [RealmOfflineProduct])
    func getOfflineProduct(forCode: String) -> RealmOfflineProduct?
    func updateOfflineProductStatus(percent: Double, savedProductsCount: Int)
    func offlineProductStatus() -> RealmOfflineProductStatus?

    // allergies settings
    func addAllergy(toAllergen: Allergen)
    func removeAllergy(toAllergen: Allergen)
    func listAllergies() -> Results<Allergen>

    // Products pending upload
    func addPendingUploadItem(_ product: Product, withNutritionTable nutriments: [RealmPendingUploadNutrimentItem]?)
    func addPendingUploadItem(_ productImage: ProductImage)
    func getItemsPendingUpload() -> [PendingUploadItem]
    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem?
    func deletePendingUploadItem(_ item: PendingUploadItem)
    func updatePendingUploadItem(_ item: PendingUploadItem)
}

class PersistenceManager: PersistenceManagerProtocol {

    fileprivate func saveOrUpdate(objects: [Object]) {
        let realm = getRealm()

        do {
            try realm.write {
                realm.add(objects, update: true)
            }
        } catch let error as NSError {
            log.error("ERROR SAVING INTO REALM \(error)")
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
    func objectSearch<T>(forQuery query: String?, ofClass: T.Type) -> Results<T>? where T: Object {
        var results = getRealm().objects(T.self)
        if let query = query, !query.isEmpty {
            results = results.filter("indexedNames CONTAINS[cd] %@", query)
        }
        return results
    }

    func save(categories: [Category]) {
        saveOrUpdate(objects: categories)
        log.info("Saved \(categories.count) categories in taxonomies database")
    }

    func category(forCode code: String) -> Category? {
        return getRealm().object(ofType: Category.self, forPrimaryKey: code)
    }

    func categorySearch(query: String? = nil) -> Results<Category> {
        var results = getRealm().objects(Category.self)
        if let query = query, !query.isEmpty {
            results = results.filter("indexedNames CONTAINS[cd] %@", query)
        }
        return results.sorted(byKeyPath: "mainName", ascending: true)
    }

    func save(allergens: [Allergen]) {
        saveOrUpdate(objects: allergens)
        log.info("Saved \(allergens.count) allergens in taxonomies database")
    }

    func allergen(forCode code: String) -> Allergen? {
        return getRealm().object(ofType: Allergen.self, forPrimaryKey: code)
    }

    func save(nutriments: [Nutriment]) {
        saveOrUpdate(objects: nutriments)
        log.info("Saved \(nutriments.count) nutriments in taxonomies database")
    }

    func nutriment(forCode code: String) -> Nutriment? {
        return getRealm().object(ofType: Nutriment.self, forPrimaryKey: code)
    }

    func nutrimentSearch(query: String?) -> Results<Nutriment> {
        var results = getRealm().objects(Nutriment.self)
        if let query = query, !query.isEmpty {
            results = results.filter("indexedNames CONTAINS[cd] %@", query)
        }
        return results.sorted(byKeyPath: "mainName", ascending: true)
    }

    func save(additives: [Additive]) {
        saveOrUpdate(objects: additives)
        log.info("Saved \(additives.count) additives in taxonomies database")
    }

    func additive(forCode code: String) -> Additive? {
        return getRealm().object(ofType: Additive.self, forPrimaryKey: code)
    }

    func save(offlineProducts: [RealmOfflineProduct]) {
        saveOrUpdate(objects: offlineProducts)
    }

    func getOfflineProduct(forCode: String) -> RealmOfflineProduct? {
        return getRealm().object(ofType: RealmOfflineProduct.self, forPrimaryKey: forCode)
    }

    // MARK: User Preferences
    fileprivate func getRealmUserPreferences() -> RealmUserPreferences {
        if let prefs = getRealm().objects(RealmUserPreferences.self).first {
            return prefs
        }
        let prefs = RealmUserPreferences()
        if prefs.offlineStatus == nil {
            prefs.offlineStatus = RealmOfflineProductStatus()
        }
        do {
            let realm = getRealm()
            try realm.write {
                realm.add(prefs)
            }
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
        return prefs
    }

    // MARK: - Allergies Settings
    func addAllergy(toAllergen: Allergen) {
        let settings = getRealmUserPreferences()
        let realm = getRealm()
        do {
            try  realm.write {
                if !settings.allergens.contains(toAllergen) {
                    settings.allergens.append(toAllergen)
                }
            }
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    func removeAllergy(toAllergen: Allergen) {
        let settings = getRealmUserPreferences()
        let realm = getRealm()
        do {
            try  realm.write {
                if let index = settings.allergens.index(of: toAllergen) {
                    settings.allergens.remove(at: index)
                }
            }
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    func updateOfflineProductStatus(percent: Double, savedProductsCount: Int) {
        let settings = getRealmUserPreferences()
        let realm = getRealm()
        do {
            try realm.write {
                if settings.offlineStatus == nil {
                    settings.offlineStatus = RealmOfflineProductStatus()
                }
                settings.offlineStatus?.percent = percent
                settings.offlineStatus?.savedProductsCount = savedProductsCount
            }
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    func offlineProductStatus() -> RealmOfflineProductStatus? {
        return getRealmUserPreferences().offlineStatus
    }

    func listAllergies() -> Results<Allergen> {
        return getRealmUserPreferences().allergens.sorted(byKeyPath: "mainName", ascending: true)
    }

    // MARK: - Products pending upload

    func addPendingUploadItem(_ product: Product, withNutritionTable nutriments: [RealmPendingUploadNutrimentItem]?) {
        guard let barcode = product.barcode else { return }

        let item = getPendingUploadItem(forBarcode: barcode) ?? PendingUploadItem(barcode: barcode)
        if let name = product.name {
            item.productName = name
        }
        if let quantity = product.quantity {
            item.quantity = quantity
        }
        if let categories = product.categories {
            item.categories = categories
        }
        if let ingredientsList = product.ingredientsList {
            item.ingredientsList = ingredientsList
        }
        if let noNutritionData = product.noNutritionData {
            item.noNutritionData = noNutritionData
        }
        if let servingSize = product.servingSize {
            item.servingSize = servingSize
        }
        if let rawValue = product.nutritionDataPer?.rawValue {
            item.nutritionDataPer = rawValue
        }
        if let nutriments = nutriments {
            item.nutriments.removeAll()
            item.nutriments.append(objectsIn: nutriments)
        }

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
                realm.add(realmItem, update: true)
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
                    realm.add(realmItem, update: true)
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
