//
//  DataManager.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import Crashlytics
import UIKit

protocol DataManagerProtocol {
    // Search
    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void)
    func getProduct(byBarcode barcode: String,
                    isScanning: Bool,
                    isSummary: Bool,
                    onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void)

    // User
    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)

    // Taxonomies
    func objectSearch<T: Object>(forQuery: String?, ofClass: T.Type) -> Results<T>?

    func category(forTag: String) -> Category?
    func categorySearch(query: String?) -> Results<Category>
    func allergen(forTag: Tag) -> Allergen?
    func additive(forTag: Tag) -> Additive?
    func nutriment(forTag: String) -> Nutriment?
    func nutrimentSearch(query: String?) -> Results<Nutriment>

    // Search history
    func getHistory() -> [Age: [HistoryItem]]
    func addHistoryItem(_ product: Product)
    func clearHistory()

    // Product - Add
    func addProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func addProductNutritionTable(_ product: Product, nutritionTable: [RealmPendingUploadNutrimentItem], onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func postImage(_ productImage: ProductImage, onSuccess: @escaping (_ isOffline: Bool) -> Void, onError: @escaping (Error) -> Void)

    func getIngredientsOCR(forBarcode: String, productLanguageCode: String, onDone: @escaping (String?, Error?) -> Void)

    // Products pending upload
    func getItemsPendingUpload() -> [PendingUploadItem]
    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem?

    ///
    /// Tries to upload all PendingUploadItems.
    ///
    /// - Parameter itemProcessedHandler: Called each time an item has been processed. The progress goes from 0.0 to 1.0
    func uploadPendingItems(mergeProcessor: ProductMergeProcessor, itemProcessedHandler: @escaping (Float) -> Void)

    // Misc
    func getLanguages() -> [Language]
}

class DataManager: DataManagerProtocol {
    var productApi: ProductApi!
    var taxonomiesApi: TaxonomiesApi!
    var persistenceManager: PersistenceManagerProtocol!

    // MARK: - Search

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        productApi.getProducts(for: query, page: page, onSuccess: { response in
            DispatchQueue.main.async {
                onSuccess(response)
            }
        }, onError: { error in
            DispatchQueue.main.async {
                onError(error)
            }
        })
    }

    func getProduct(byBarcode barcode: String, isScanning: Bool, isSummary: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void) {
        productApi.getProduct(byBarcode: barcode, isScanning: isScanning, isSummary: isSummary, onSuccess: { response in
            DispatchQueue.main.async {
                onSuccess(response)
            }
        }, onError: { error in
            DispatchQueue.main.async {
                onError(error)
            }
        })
    }

    // MARK: - User

    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        productApi.logIn(username: username, password: password, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
        }, onError: { error in
            DispatchQueue.main.async {
                onError(error)
            }
        })
    }

    // MARK: - Taxonomies
    func objectSearch<T>(forQuery query: String?, ofClass: T.Type) -> Results<T>? where T: Object {
        return persistenceManager.objectSearch(forQuery: query, ofClass: T.self)
    }

    func category(forTag tag: String) -> Category? {
        return persistenceManager.category(forCode: tag)
    }

    func categorySearch(query: String?) -> Results<Category> {
        return persistenceManager.categorySearch(query: query)
    }

    func allergen(forTag tag: Tag) -> Allergen? {
        return persistenceManager.allergen(forCode: tag.languageCode + ":" + tag.value)
    }

    func additive(forTag tag: Tag) -> Additive? {
        return persistenceManager.additive(forCode: tag.languageCode + ":" + tag.value)
    }

    func nutriment(forTag tag: String) -> Nutriment? {
        return persistenceManager.nutriment(forCode: tag)
    }

    func nutrimentSearch(query: String?) -> Results<Nutriment> {
        return persistenceManager.nutrimentSearch(query: query)
    }

    // MARK: - Search history

    func getHistory() -> [Age: [HistoryItem]] {
        let items = persistenceManager.getHistory()

        var history = [Age: [HistoryItem]]()
        for item in items {
            if history[item.age] == nil {
                history[item.age] = [item]
            } else {
                history[item.age]?.append(item)
            }
        }

        return history
    }

    func addHistoryItem(_ product: Product) {
        persistenceManager.addHistoryItem(product)
    }

    func clearHistory() {
        persistenceManager.clearHistory()
    }

    // MARK: - Product Add

    func addProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        productApi.postProduct(product, rawParameters: nil, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
        }, onError: { error in
            if isOffline(errorCode: (error as NSError).code) {
                self.persistenceManager.addPendingUploadItem(product, withNutritionTable: nil)
                DispatchQueue.main.async {
                    onSuccess()
                }
            } else {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        })
    }

    func addProductNutritionTable(_ product: Product, nutritionTable: [RealmPendingUploadNutrimentItem], onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {

        var params = [String: Any]()
        nutritionTable.forEach { (item) in
            params["nutriment_\(item.code)"] = item.value
            params["nutriment_\(item.code)_unit"] = item.unit
        }

        productApi.postProduct(product, rawParameters: params, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
        }, onError: { error in
            if isOffline(errorCode: (error as NSError).code) {
                self.persistenceManager.addPendingUploadItem(product, withNutritionTable: nutritionTable)
                DispatchQueue.main.async {
                    onSuccess()
                }
            } else {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        })
    }

    func postImage(_ productImage: ProductImage, onSuccess: @escaping (_ isOffline: Bool) -> Void, onError: @escaping (Error) -> Void) {
        productApi.postImage(productImage, onSuccess: {
            DispatchQueue.main.async {
                onSuccess(false)
            }
        }, onError: { error in
            if isOffline(errorCode: (error as NSError).code) {
                self.persistenceManager.addPendingUploadItem(productImage)
                DispatchQueue.main.async {
                    onSuccess(true)
                }
            } else {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        })
    }

    func getIngredientsOCR(forBarcode: String, productLanguageCode: String, onDone: @escaping (String?, Error?) -> Void) {
        productApi.getIngredientsOCR(forBarcode: forBarcode, productLanguageCode: productLanguageCode, onDone: onDone)
    }

    // MARK: - Products pending upload

    func getItemsPendingUpload() -> [PendingUploadItem] {
        return persistenceManager.getItemsPendingUpload()
    }

    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem? {
        return persistenceManager.getItemPendingUpload(forBarcode: barcode)
    }

    func uploadPendingItems(mergeProcessor: ProductMergeProcessor = PendingProductMergeProcessor(), itemProcessedHandler: @escaping (Float) -> Void) {
        let items = self.persistenceManager.getItemsPendingUpload()

        for (index, item) in items.enumerated() {

            DispatchQueue.global(qos: .background).async {
                self.uploadPendingItem(mergeProcessor, item)

                // Update caller with progress
                DispatchQueue.main.async {
                    itemProcessedHandler(Float(index + 1) / Float(items.count))
                }
            }
        }
    }

    // swiftlint:disable:next function_body_length
    private func uploadPendingItem(_ mergeProcessor: ProductMergeProcessor, _ item: PendingUploadItem) {
        log.debug("Trying to upload PendingUploadItem, going to check if a product for the barcode \(item.barcode) already exists on the server")

        let itemSemaphore = DispatchSemaphore(value: 0)

        // Check if product exists
        self.productApi.getProduct(byBarcode: item.barcode, isScanning: false, isSummary: false, onSuccess: { product in
            var productToUpload: Product?
            var nutrimentsToUpload: [RealmPendingUploadNutrimentItem]?

            // If exists, merge with PendingUploadItem and try to upload to the server the changes
            // If it does not, upload all the info in PendingUploadItem (this will be the case when the product is new)

            if let product = product {
                let (mergedProduct, mergedNutriments) = mergeProcessor.merge(item, product)
                if let mergedProduct = mergedProduct {
                    log.debug("Product exists but there is new info to upload")
                    productToUpload = mergedProduct
                }
                if let mergedNutriments = mergedNutriments {
                    nutrimentsToUpload = mergedNutriments
                }
            }
            if productToUpload == nil {
                log.debug("Product does not exist, going to upload the info we have")
                productToUpload = item.toProduct()
            }

            let mergeTasks = DispatchGroup()

            // Upload product and images

            var productSuccess = false
            var frontImageSuccess = false
            var ingredientsImageSuccess = false
            var nutritionTableImageSuccess = false

            self.uploadProduct(productToUpload, nutritionTable: nutrimentsToUpload, group: mergeTasks) { success in productSuccess = success }
            self.uploadImage(item.frontImage, mergeTasks) { success in frontImageSuccess = success }
            self.uploadImage(item.ingredientsImage, mergeTasks) { success in ingredientsImageSuccess = success }
            self.uploadImage(item.nutritionImage, mergeTasks) { success in nutritionTableImageSuccess = success }

            // Wait for the four tasks to finish
            mergeTasks.wait()

            log.debug("""
                All PendingUploadItem should be uploaded. ProductInfo success? \(productSuccess), Front Image success? \(frontImageSuccess),
                Ingredients Image success? \(ingredientsImageSuccess), NutritionTable Image success? \(nutritionTableImageSuccess)
                """)

            if productSuccess && frontImageSuccess && ingredientsImageSuccess && nutritionTableImageSuccess {
                self.persistenceManager.deletePendingUploadItem(item)
            } else {
                if productSuccess {
                    item.productName = nil
                    item.brand = nil
                    item.quantity = nil
                    item.categories = nil
                    item.ingredientsList = nil
                    item.nutriments.removeAll()
                }

                if frontImageSuccess {
                    item.frontImage = nil
                }

                if ingredientsImageSuccess {
                    item.ingredientsImage = nil
                }

                if nutritionTableImageSuccess {
                    item.nutritionImage = nil
                }

                log.debug("Some info did not upload successfully, updating PendingUploadItem")
                self.persistenceManager.updatePendingUploadItem(item)
            }

            itemSemaphore.signal()
        }, onError: { _ in
            // Skip the item

            itemSemaphore.signal()
        })

        itemSemaphore.wait()
    }

    private func uploadProduct(_ product: Product?, nutritionTable: [RealmPendingUploadNutrimentItem]?, group: DispatchGroup, completionHandler: @escaping (Bool) -> Void) {
        group.enter()

        let successHandler = {
            completionHandler(true)
            group.leave()
        }

        guard let product = product else {
            // If there is no product to upload, treat it as a success
            successHandler()
            return
        }

        var params = [String: Any]()
        nutritionTable?.forEach { (item) in
            params["nutriment_\(item.code)"] = item.value
            params["nutriment_\(item.code)_unit"] = item.unit
        }

        log.debug("Uploading product info of a PendingUploadItem...")

        productApi.postProduct(product, rawParameters: params, onSuccess: {
            successHandler()
        }, onError: { _ in
            completionHandler(false)
            group.leave()
        })
    }

    private func uploadImage(_ productImage: ProductImage?, _ group: DispatchGroup, completionHandler: @escaping (Bool) -> Void) {
        group.enter()

        let successHandler = {
            completionHandler(true)
            group.leave()
        }

        guard let productImage = productImage else {
            // If there is no image, treat it as a success case
            successHandler()
            return
        }

        log.debug("Uploading product image of a PendingUploadItem...")

        productApi.postImage(productImage, onSuccess: {
            productImage.deleteImage()
            successHandler()
        }, onError: { _ in
            // Ignore error, will retry to upload next time
            completionHandler(false)
            group.leave()
        })
    }

    // MARK: - Misc

    func getLanguages() -> [Language] {
        // Get all ISO 639-1 languages
        return Locale.isoLanguageCodes
            .filter({ $0.count == 2 }) // Filter all codes that don't have two letters so we only keep two letter codes, aka ISO 639-1 codes
            .compactMap({ // Weed out all languages where we don't have a localized language name
                let code = $0
                if let name = Locale.current.localizedString(forIdentifier: $0) {
                    return Language(code: code, name: name)
                } else {
                    return nil
                }
            })
            .sorted(by: { $0.name < $1.name }) // Sort alphabetically
    }

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
