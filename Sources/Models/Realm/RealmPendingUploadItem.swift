//
//  RealmPendingUploadItem.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift

// Realm class, cloned from PendingUploadItem.
//Outside of PersistanceManager PendingUploadItem will be used for easier work across threads.

internal class RealmPendingUploadItem: Object {
    @objc dynamic var barcode = ""
    @objc dynamic var productName: String?
    @objc dynamic var brand: String?
    @objc dynamic var quantityValue: String?
    @objc dynamic var quantityUnit: String?
    @objc dynamic var language = "en"
    @objc dynamic var frontImageName: String?
    @objc dynamic var ingredientsImageName: String?
    @objc dynamic var nutritionImageName: String?

    override static func primaryKey() -> String? {
        return "barcode"
    }

    func fromPendingUploadItem(_ pendingUploadItem: PendingUploadItem) -> RealmPendingUploadItem {
        if self.barcode == "" {
            // Set primary key when new item created
            self.barcode = pendingUploadItem.barcode
        }

        self.productName = pendingUploadItem.productName
        self.brand = pendingUploadItem.brand
        self.quantityValue = pendingUploadItem.quantityValue
        self.quantityUnit = pendingUploadItem.quantityUnit
        self.language = pendingUploadItem.language
        self.frontImageName = pendingUploadItem.frontImage?.fileName
        self.ingredientsImageName = pendingUploadItem.ingredientsImage?.fileName
        self.nutritionImageName = pendingUploadItem.nutritionImage?.fileName

        return self
    }

    func toPendingUploadItem() -> PendingUploadItem {
        let pendingUploadItem = PendingUploadItem(barcode: barcode)

        pendingUploadItem.productName = self.productName
        pendingUploadItem.brand = self.brand
        pendingUploadItem.quantityValue = self.quantityValue
        pendingUploadItem.quantityUnit = self.quantityUnit
        pendingUploadItem.language = self.language

        if let imageName = self.frontImageName {
            pendingUploadItem.frontImage = ProductImage(barcode: barcode, fileName: imageName, type: .front)
        }

        if let imageName = self.ingredientsImageName {
            pendingUploadItem.ingredientsImage = ProductImage(barcode: barcode, fileName: imageName, type: .ingredients)
        }

        if let imageName = self.nutritionImageName {
            pendingUploadItem.nutritionImage = ProductImage(barcode: barcode, fileName: imageName, type: .nutrition)
        }

        return pendingUploadItem
    }
}
