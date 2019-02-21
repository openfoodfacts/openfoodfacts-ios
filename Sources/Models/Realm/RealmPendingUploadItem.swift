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

internal class RealmPendingUploadNutrimentItem: Object {
    @objc dynamic var code: String = ""
    @objc dynamic var value: Double = 0
    @objc dynamic var unit: String = ""
}

internal class RealmPendingUploadItem: Object {
    @objc dynamic var barcode = ""
    @objc dynamic var productName: String?
    @objc dynamic var brand: String?
    @objc dynamic var quantity: String?
    @objc dynamic var language = "en"
    @objc dynamic var frontImageName: String?
    @objc dynamic var ingredientsImageName: String?
    @objc dynamic var nutritionImageName: String?
    @objc dynamic var ingredientsList: String?
    let categories = List<String>()

    @objc dynamic var noNutritionData: String?
    @objc dynamic var servingSize: String?
    @objc dynamic var nutritionDataPer: String?
    let nutriments = List<RealmPendingUploadNutrimentItem>()

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
        self.quantity = pendingUploadItem.quantity
        self.language = pendingUploadItem.language
        self.frontImageName = pendingUploadItem.frontImage?.fileName
        self.ingredientsImageName = pendingUploadItem.ingredientsImage?.fileName
        self.nutritionImageName = pendingUploadItem.nutritionImage?.fileName
        self.ingredientsList = pendingUploadItem.ingredientsList
        self.categories.removeAll()
        if let categories = pendingUploadItem.categories {
            self.categories.append(objectsIn: categories)
        }

        self.noNutritionData = pendingUploadItem.noNutritionData
        self.servingSize = pendingUploadItem.servingSize
        self.nutritionDataPer = pendingUploadItem.nutritionDataPer
        self.nutriments.removeAll()
        self.nutriments.append(objectsIn: pendingUploadItem.nutriments)

        return self
    }

    func toPendingUploadItem() -> PendingUploadItem {
        let pendingUploadItem = PendingUploadItem(barcode: barcode)

        pendingUploadItem.productName = self.productName
        pendingUploadItem.brand = self.brand
        pendingUploadItem.quantity = self.quantity
        pendingUploadItem.language = self.language
        pendingUploadItem.categories = self.categories.map { $0 }
        pendingUploadItem.ingredientsList = self.ingredientsList

        pendingUploadItem.noNutritionData = self.noNutritionData
        pendingUploadItem.servingSize = self.servingSize
        pendingUploadItem.nutritionDataPer = self.nutritionDataPer
        pendingUploadItem.nutriments.removeAll()
        pendingUploadItem.nutriments.append(objectsIn: self.nutriments)

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
