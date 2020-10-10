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
    // =======------------------======= //
    // TODO: implement code below if needed (for now only add the function/propety signatures, so it builds)
    // =======------------------======= //

    var categoriesIsEmpty: Bool = false

    func country(forCode: String) -> Country? {
        return nil
    }

    var countriesIsEmpty: Bool = false

    func save(countries: [Country]) {
    }

    var allergensIsEmpty: Bool = false

    var mineralsIsEmpty: Bool = false

    var vitaminsIsEmpty: Bool = false

    var nucleotidesIsEmpty: Bool = false

    func save(ingredientsAnalysis: [IngredientsAnalysis]) {
    }

    var ingredientsAnalysisIsEmpty: Bool = false

    func save(ingredientsAnalysisConfig: [IngredientsAnalysisConfig]) {
    }

    var ingredientsAnalysisConfigIsEmpty: Bool = false

    func clearInvalidBarcodes() {
    }

    func save(invalidBarcodes: [InvalidBarcode]) {
    }

    func invalidBarcode(forBarcode: String) -> InvalidBarcode? {
        return nil
    }

    var otherNutritionalSubstancesIsEmpty: Bool = false

    func save(otherNutritionalSubstance: [OtherNutritionalSubstance]) {
    }

    func ingredientsAnalysis(forCode: String) -> IngredientsAnalysis? {
        return nil
    }

    func ingredientsAnalysisConfig(forCode: String) -> IngredientsAnalysisConfig? {
        return nil
    }

    var nutrimentsIsEmpty: Bool = false

    func save(tagLine: Tagline) {
    }

    func tagLine() -> Tagline? {
        return nil
    }

    var additivesIsEmpty: Bool = false

    // =======------------------======= //

    // Common
    var product: Product?
    var pendingUploadItem: PendingUploadItem?

    // getHistory
    var getHistoryCalled = false
    var history: [HistoryItem]?

    // addHistoryItem
    var addHistoryItemCalled = false

    // removeHistoryItem
    var removeHistoryItemCalled = false

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

    func removeHistroyItem(_ item: HistoryItem) {
        self.removeHistoryItemCalled = true
        self.history = nil
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

    // MARK: - Allergens settings
    func addAllergy(toAllergen: Allergen) {
    }

    func removeAllergy(toAllergen: Allergen) {
    }

    func listAllergies() -> Results<Allergen> {
        return realm().objects(Allergen.self)
    }

    // MARK: - Products pending upload
    func addPendingUploadItem(_ product: Product, withNutritionTable nutriments: [RealmPendingUploadNutrimentItem]?) {
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

    func save(minerals: [Mineral]) {
    }

    func save(vitamins: [Vitamin]) {
    }

    func save(nucleotides: [Nucleotide]) {
    }

    func trace(forCode: String) -> Allergen? {
        return nil
    }

    func vitamin(forCode: String) -> Vitamin? {
        return nil
    }

    func mineral(forCode: String) -> Mineral? {
        return nil
    }

    func nucleotide(forCode: String) -> Nucleotide? {
        return nil
    }

    func otherNutritionalSubstance(forCode: String) -> OtherNutritionalSubstance? {
        return nil
    }

    func save(labels: [Label]) {
    }

    func label(forCode: String) -> Label? {
        return nil
    }

    func save(offlineProducts: [RealmOfflineProduct]) {
    }

    func getOfflineProduct(forCode: String) -> RealmOfflineProduct? {
        return nil
    }

    func updateOfflineProductStatus(percent: Double, savedProductsCount: Int) {
    }

    func offlineProductStatus() -> RealmOfflineProductStatus? {
        return nil
    }
}
