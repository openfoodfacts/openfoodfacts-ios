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
    func getProduct(byBarcode barcode: String, isScanning: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void)

    // User
    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)

    // Search history
    func getHistory() -> [Age: [HistoryItem]]
    func addHistoryItem(_ product: Product)
    func clearHistory()

    // Product - Add
    func addProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)

    // Products pending upload
    func getItemsPendingUpload() -> [PendingUploadItem]

    // Misc
    func getLanguages() -> [Language]
}

class DataManager: DataManagerProtocol {
    var productApi: ProductApi!
    var persistenceManager: PersistenceManagerProtocol!

    // MARK: - Search

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        productApi.getProducts(for: query, page: page, onSuccess: onSuccess, onError: onError)
    }

    func getProduct(byBarcode barcode: String, isScanning: Bool, onSuccess: @escaping (Product?) -> Void, onError: @escaping (Error) -> Void) {
        productApi.getProduct(byBarcode: barcode, isScanning: isScanning, onSuccess: onSuccess, onError: onError)
    }

    // MARK: - User

    func logIn(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        productApi.logIn(username: username, password: password, onSuccess: onSuccess, onError: onError)
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
        productApi.postProduct(product, onSuccess: onSuccess, onError: { error in

            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                self.persistenceManager.addPendingUploadItem(product)
                onSuccess()
            } else {
                onError(error)
            }
        })
    }

    func postImage(_ productImage: ProductImage, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        productApi.postImage(productImage, onSuccess: onSuccess) { error in
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                self.persistenceManager.addPendingUploadItem(productImage)
                onSuccess()
            } else {
                onError(error)
            }
        }
    }

    // MARK: - Products pending upload

    func getItemsPendingUpload() -> [PendingUploadItem] {
        return persistenceManager.getItemsPendingUpload()
    }

    // MARK: - Misc

    func getLanguages() -> [Language] {
        // Get all ISO 639-1 languages
        return Locale.isoLanguageCodes
            .filter({ $0.count == 2 })
            .flatMap({
                let code = $0
                if let name = Locale.current.localizedString(forIdentifier: $0) {
                    return Language(code: code, name: name)
                } else {
                    return nil
                }
            })
            .sorted(by: { $0.name < $1.name })
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
