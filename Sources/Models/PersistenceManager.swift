//
//  PersistenceManager.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 21/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

protocol PersistenceManagerProtocol {
    // Search history
    func getHistory() -> [HistoryItem]
    func addHistoryItem(_ product: Product)
    func removeHistroyItem(_ item: HistoryItem)
    func clearHistory()

    // taxonomies
    func objectSearch<T: Object>(forQuery: String?, ofClass: T.Type) -> Results<T>?

    func save(categories: [Category])
    func category(forCode: String) -> Category?
    var categoriesIsEmpty: Bool { get }
    func categorySearch(query: String?) -> Results<Category>
    func country(forCode: String) -> Country?
    var countriesIsEmpty: Bool { get }
    func save(countries: [Country])

    func save(allergens: [Allergen])
    var allergensIsEmpty: Bool { get }
    func save(minerals: [Mineral])
    var mineralsIsEmpty: Bool { get }
    func save(vitamins: [Vitamin])
    var vitaminsIsEmpty: Bool { get }
    func save(nucleotides: [Nucleotide])
    var nucleotidesIsEmpty: Bool { get }
    func save(ingredientsAnalysis: [IngredientsAnalysis])
    var ingredientsAnalysisIsEmpty: Bool { get }
    func save(ingredientsAnalysisConfig: [IngredientsAnalysisConfig])
    var ingredientsAnalysisConfigIsEmpty: Bool { get }
    func clearInvalidBarcodes()
    func save(invalidBarcodes: [InvalidBarcode])
    func invalidBarcode(forBarcode: String) -> InvalidBarcode?
    func allergen(forCode: String) -> Allergen?
    func trace(forCode: String) -> Allergen?
    func vitamin(forCode: String) -> Vitamin?
    func mineral(forCode: String) -> Mineral?
    func nucleotide(forCode: String) -> Nucleotide?
    func otherNutritionalSubstance(forCode: String) -> OtherNutritionalSubstance?
    var otherNutritionalSubstancesIsEmpty: Bool { get }
    func save(otherNutritionalSubstance: [OtherNutritionalSubstance])
    func ingredientsAnalysis(forCode: String) -> IngredientsAnalysis?
    func ingredientsAnalysisConfig(forCode: String) -> IngredientsAnalysisConfig?

    func save(nutriments: [Nutriment])
    func nutriment(forCode: String) -> Nutriment?
    var nutrimentsIsEmpty: Bool { get }
    func nutrimentSearch(query: String?) -> Results<Nutriment>

    func save(additives: [Additive])
    func additive(forCode: String) -> Additive?
    func save(tagLine: Tagline)
    func tagLine() -> Tagline?
    var additivesIsEmpty: Bool { get }

    func save(labels: [Label])
    func label(forCode: String) -> Label?
    var labelsIsEmpty: Bool { get }

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

    func removeHistroyItem(_ item: HistoryItem) {
        let realm = self.getRealm()

        do {
            try realm.write {
                realm.delete(item)
            }
        } catch let error as NSError {
            AnalyticsManager.record(error: error)
        }
    }

    fileprivate func saveOrUpdate(objects: [Object]) {
        let realm = getRealm()

        do {
            try realm.write {
                realm.add(objects, update: .all)
            }
        } catch let error as NSError {
            AnalyticsManager.record(error: error)
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
                item.packaging = product.packaging?.compactMap {$0}.joined(separator: ", ")
                item.imageUrl = product.imageUrl
                item.nutriscore = product.nutriscore
                item.novaGroup.value = product.novaGroup
                item.timestamp = Date()

                if let brands = product.brands, !brands.isEmpty {
                    item.brand = brands[0]
                }

                try realm.write {
                    realm.add(item, update: .all)
                }
            } catch let error as NSError {
                AnalyticsManager.record(error: error)
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
                AnalyticsManager.record(error: error)
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

    var categoriesIsEmpty: Bool {
        getRealm().objects(Category.self).isEmpty
    }

    func category(forCode code: String) -> Category? {
        return getRealm().object(ofType: Category.self, forPrimaryKey: code)
    }

    func country(forCode code: String) -> Country? {
                return getRealm().object(ofType: Country.self, forPrimaryKey: code)
    }

    func save(countries: [Country]) {
        saveOrUpdate(objects: countries)
        log.info("Saved \(countries.count) countries in taxonomy database")
    }

    var countriesIsEmpty: Bool {
        getRealm().objects(Country.self).isEmpty
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

    var allergensIsEmpty: Bool {
        getRealm().objects(Allergen.self).isEmpty
    }

    func save(vitamins: [Vitamin]) {
        saveOrUpdate(objects: vitamins)
        log.info("Saved \(vitamins.count) vitamins in taxonomies database")
    }

    var vitaminsIsEmpty: Bool {
        getRealm().objects(Vitamin.self).isEmpty
    }

    func save(minerals: [Mineral]) {
        saveOrUpdate(objects: minerals)
        log.info("Saved \(minerals.count) minerals in taxonomies database")
    }

    var mineralsIsEmpty: Bool {
        getRealm().objects(Mineral.self).isEmpty
    }

    func save(nucleotides: [Nucleotide]) {
        saveOrUpdate(objects: nucleotides)
        log.info("Saved \(nucleotides.count) nucleotides in taxonomies database")
    }

    var nucleotidesIsEmpty: Bool {
        getRealm().objects(Nucleotide.self).isEmpty
    }

    func allergen(forCode code: String) -> Allergen? {
        return getRealm().object(ofType: Allergen.self, forPrimaryKey: code)
    }

    func clearInvalidBarcodes() {
        let realm = self.getRealm()
        do {
            let barcodes = realm.objects(InvalidBarcode.self)
            try realm.write {
                realm.delete(barcodes)
            }
        } catch let error as NSError {
            AnalyticsManager.record(error: error)
        }
    }

    func save(invalidBarcodes: [InvalidBarcode]) {
        saveOrUpdate(objects: invalidBarcodes)
        log.info("Saved \(invalidBarcodes.count) invalid barcodes database")
    }

    func invalidBarcode(forBarcode barcode: String) -> InvalidBarcode? {
        return getRealm().object(ofType: InvalidBarcode.self, forPrimaryKey: barcode)
    }

    func trace(forCode code: String) -> Allergen? {
        return getRealm().object(ofType: Allergen.self, forPrimaryKey: code)
    }

    func vitamin(forCode code: String) -> Vitamin? {
        return getRealm().object(ofType: Vitamin.self, forPrimaryKey: code)
    }

    func mineral(forCode code: String) -> Mineral? {
        return getRealm().object(ofType: Mineral.self, forPrimaryKey: code)
    }

    func nucleotide(forCode code: String) -> Nucleotide? {
        return getRealm().object(ofType: Nucleotide.self, forPrimaryKey: code)
    }

    func save(otherNutritionalSubstance: [OtherNutritionalSubstance]) {
        saveOrUpdate(objects: otherNutritionalSubstance)
        log.info("Saved \(otherNutritionalSubstance.count) otherNutritionalSubstance in taxonomies database")
    }

    func otherNutritionalSubstance(forCode code: String) -> OtherNutritionalSubstance? {
        return getRealm().object(ofType: OtherNutritionalSubstance.self, forPrimaryKey: code)
    }

    var otherNutritionalSubstancesIsEmpty: Bool {
        getRealm().objects(OtherNutritionalSubstance.self).isEmpty
    }

    func save(nutriments: [Nutriment]) {
        saveOrUpdate(objects: nutriments)
        log.info("Saved \(nutriments.count) nutriments in taxonomies database")
    }

    func nutriment(forCode code: String) -> Nutriment? {
        return getRealm().object(ofType: Nutriment.self, forPrimaryKey: code)
    }

    var nutrimentsIsEmpty: Bool {
        getRealm().objects(Nutriment.self).isEmpty
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

    var additivesIsEmpty: Bool {
        getRealm().objects(Additive.self).isEmpty
    }

    func additive(forCode code: String) -> Additive? {
        return getRealm().object(ofType: Additive.self, forPrimaryKey: code)
    }

    func save(tagLine: Tagline) {
        tagLine.id = "unique"
        saveOrUpdate(objects: [tagLine])
    }

    func tagLine() -> Tagline? {
        return getRealm().object(ofType: Tagline.self, forPrimaryKey: "unique")
    }

    func save(ingredientsAnalysis: [IngredientsAnalysis]) {
        saveOrUpdate(objects: ingredientsAnalysis)
        log.info("Saved \(ingredientsAnalysis.count) ingredients analysis in taxonomies database")
    }

    var ingredientsAnalysisIsEmpty: Bool {
        getRealm().objects(IngredientsAnalysis.self).isEmpty
    }

    func save(ingredientsAnalysisConfig: [IngredientsAnalysisConfig]) {
        saveOrUpdate(objects: ingredientsAnalysisConfig)
        log.info("Saved \(ingredientsAnalysisConfig.count) ingredients analysis configs in files database")
    }

    var ingredientsAnalysisConfigIsEmpty: Bool {
        getRealm().objects(IngredientsAnalysisConfig.self).isEmpty
    }

    func ingredientsAnalysis(forCode code: String) -> IngredientsAnalysis? {
        return getRealm().object(ofType: IngredientsAnalysis.self, forPrimaryKey: code)
    }

    func ingredientsAnalysisConfig(forCode code: String) -> IngredientsAnalysisConfig? {
        return getRealm().object(ofType: IngredientsAnalysisConfig.self, forPrimaryKey: code)
    }

    func save(labels: [Label]) {
        saveOrUpdate(objects: labels)
        log.info("Saved \(labels.count) labels in taxonomy database")
    }

    func label(forCode code: String) -> Label? {
        return getRealm().object(ofType: Label.self, forPrimaryKey: code)
    }

    var labelsIsEmpty: Bool {
        getRealm().objects(Label.self).isEmpty
    }

    // Offline Products
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
            AnalyticsManager.record(error: error)
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
            AnalyticsManager.record(error: error)
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
            AnalyticsManager.record(error: error)
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
            AnalyticsManager.record(error: error)
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
        if let packaging = product.packaging {
            item.packaging = packaging.compactMap {$0}.joined(separator: ", ")
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
                realm.add(realmItem, update: .all)
            }

            let count = getItemsPendingUpload().count
            NotificationCenter.default.post(name: .pendingUploadBadgeChange, object: nil, userInfo: [NotificationUserInfoKey.pendingUploadItemCount: count])
        } catch let error as NSError {
            AnalyticsManager.record(error: error)
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
                default:
                    break
                }

                let realmItem = RealmPendingUploadItem().fromPendingUploadItem(item)

                try realm.write {
                    realm.add(realmItem, update: .all)
                }
            } catch let error as NSError {
                AnalyticsManager.record(error: error)
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
                AnalyticsManager.record(error: error)
            }
        }
    }

    func updatePendingUploadItem(_ item: PendingUploadItem) {
        DispatchQueue.global(qos: .background).async {
            let realm = self.getRealm()
            do {
                let realmItem = RealmPendingUploadItem().fromPendingUploadItem(item)
                try realm.write {
                    realm.add(realmItem, update: .all)
                }
            } catch let error as NSError {
                AnalyticsManager.record(error: error)
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
            AnalyticsManager.record(error: error)
        }
        fatalError("Could not get Realm instance")
    }
}
