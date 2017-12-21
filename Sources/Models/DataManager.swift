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
    // Search history
    func getHistory() -> [Age: [HistoryItem]]
    func addHistoryItem(_ product: Product)
    func clearHistory()

    // Product - Add
    func addProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func getItemsPendingUpload() -> [PendingUploadItem]
}

class DataManager: DataManagerProtocol, ProductApiClient {
    var productApi: ProductApi!
    var persistenceManager: PersistenceManagerProtocol!

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
            } else {
                onError(error)
            }
        })
    }

    func getItemsPendingUpload() -> [PendingUploadItem] {
        let realm = getRealm()
        let items = Array(realm.objects(PendingUploadItem.self))

        for item in items {
            item.frontImage = UIImage(contentsOfFile: item.frontUrl)
            item.ingredientsImage = UIImage(contentsOfFile: item.ingredientsUrl)
            item.nutritionImage = UIImage(contentsOfFile: item.nutritionUrl)
        }

        return items
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
