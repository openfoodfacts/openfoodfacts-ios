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

    // Products pending upload
    func addPendingUploadItem(_ product: Product)
    func addPendingUploadItem(_ productImage: ProductImage)
    func getItemsPendingUpload() -> [PendingUploadItem]
    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem?
}

class PersistenceManager: PersistenceManagerProtocol {

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

    // MARK: - Products pending upload

    func addPendingUploadItem(_ product: Product) {
        guard let barcode = product.barcode else { return }

        let item = getPendingUploadItem(forBarcode: barcode) ?? PendingUploadItem()
        item.productName = product.name
        item.quantityValue = product.quantityValue
        item.quantityUnit = product.quantityUnit

        if item.barcode == "" {
            // Set primary key when new item created
            item.barcode = barcode
        }

        if let brands = product.brands {
            item.brand = brands[0]
        }

        if let frontImage = item.frontImage, let url = saveImage(frontImage) {
            item.frontUrl = url
        }

        if let ingredientsImage = item.ingredientsImage, let url = saveImage(ingredientsImage) {
            item.ingredientsUrl = url
        }

        if let nutritionImage = item.nutritionImage, let url = saveImage(nutritionImage) {
            item.nutritionUrl = url
        }

        // Save in Realm
        let realm = getRealm()

        do {
            try realm.write {
                realm.add(item)
            }
        } catch let error as NSError {
            log.error(error)
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    func addPendingUploadItem(_ productImage: ProductImage) {
        DispatchQueue.global(qos: .background).async {
            let realm = self.getRealm()
            let item = self.getPendingUploadItem(forBarcode: productImage.barcode) ?? PendingUploadItem()

            do {
                try realm.write {
                    if item.barcode == "" {
                        // Set primary key when new item created
                        item.barcode = productImage.barcode
                    }

                    switch productImage.type {
                    case .front:
                        if let url = self.saveImage(productImage.image) {
                            item.frontUrl = url
                        }
                    case .ingredients:
                        if let url = self.saveImage(productImage.image) {
                            item.ingredientsUrl = url
                        }
                    case .nutrition:
                        if let url = self.saveImage(productImage.image) {
                            item.nutritionUrl = url
                        }
                    }

                    realm.add(item)
                }
            } catch let error as NSError {
                log.error(error)
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    func getItemsPendingUpload() -> [PendingUploadItem] {
        let realm = getRealm()
        let items = Array(realm.objects(PendingUploadItem.self))

        for item in items {
            item.frontImage = loadImage(item.frontUrl)
            item.ingredientsImage = loadImage(item.ingredientsUrl)
            item.nutritionImage = loadImage(item.nutritionUrl)
        }

        return items
    }

    func getItemPendingUpload(forBarcode barcode: String) -> PendingUploadItem? {
        let realm = getRealm()
        return realm.object(ofType: PendingUploadItem.self, forPrimaryKey: barcode)
    }

    private func getPendingUploadItem(forBarcode barcode: String) -> PendingUploadItem? {
        let realm = getRealm()
        return realm.object(ofType: PendingUploadItem.self, forPrimaryKey: barcode)
    }

    private func saveImage(_ image: UIImage) -> String? {
        let imageName = "\(UUID().uuidString).jpg"
        let data = UIImageJPEGRepresentation(image, 1.0)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documentsURL.appendingPathComponent(imageName)

        do {
            try data?.write(to: imageURL)
            return imageName
        } catch {
            return nil
        }
    }

    private func loadImage(_ imageName: String?) -> UIImage? {
        do {
            guard let imageName = imageName else { return nil }
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = documentsURL.appendingPathComponent(imageName)
            let imageData = try Data(contentsOf: imageURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
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
