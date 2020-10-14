//
//  ScanProductSummaryViewAdaptor.swift
//  OpenFoodFacts
//
//  Created by David_Lam on 22/10/19.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import UIKit

struct ScanProductSummaryViewAdaptor {
    let title: String?
    let quantityText: String?
    let productImageURL: URL?
    let brands: String?
    let nutriScore: NutriScoreView.Score? // NutriScore should be outside of NutriScoreView namespace/ scope???
    let novaGroup: NovaGroupView.NovaGroup? // NovaGroup should be outside of NovaGroupView namespace/scope???
    let environmentalImage: UIImage?
    let delegate: ScanProductSummaryViewProtocol?
}

struct ScanProductSummaryViewAdaptorFactory {
    static func makeAdaptor(from product: RealmOfflineProduct, delegate: ScanProductSummaryViewProtocol?) -> ScanProductSummaryViewAdaptor {
        return ScanProductSummaryViewAdaptor(title: product.name,
                                             quantityText: getQuantity(from: product),
                                             productImageURL: nil,
                                             brands: getBrands(from: product),
                                             nutriScore: getNutriScore(from: product),
                                             novaGroup: getNovaGroup(from: product),
                                             environmentalImage: nil,
                                             delegate: delegate)
    }

    static func makeAdaptor(from product: Product, delegate:ScanProductSummaryViewProtocol?) -> ScanProductSummaryViewAdaptor {
        return ScanProductSummaryViewAdaptor(title: product.name,
                                             quantityText: getQuantity(from: product),
                                             productImageURL: getImageURL(from: product),
                                             brands: getBrands(from: product),
                                             nutriScore: getNutriScore(from: product),
                                             novaGroup: getNovaGroup(from: product),
                                             environmentalImage: getEnvironmentalImpaceImage(from: product),
                                             delegate: delegate)
    }
}

// MARK: - Product
private func getImageURL(from product: Product) -> URL? {
    guard let imageUrl = product.frontImageSmallUrl ?? product.imageSmallUrl ??  product.frontImageUrl ?? product.imageUrl,
        let url = URL(string: imageUrl) else {
            return nil
    }
    return url
}

private func getBrands(from product: Product) -> String? {
    guard let brands = product.brands,
        !brands.isEmpty else {
            return nil
    }
    return brands.joined(separator: ", ")
}

private func getQuantity(from product: Product) -> String? {
    guard let quantity = product.quantity,
        !quantity.isEmpty else {
            return nil
    }
    return quantity
}

private func getNutriScore(from product: Product) -> NutriScoreView.Score? {
    guard let nutriscoreValue = product.nutriscore,
        let score = NutriScoreView.Score(rawValue: nutriscoreValue) else {
            return nil
    }
    return score
}

private func getNovaGroup(from product: Product) -> NovaGroupView.NovaGroup? {
    guard let novaGroupValue = product.novaGroup,
        let novaGroup = NovaGroupView.NovaGroup(rawValue: "\(novaGroupValue)") else {
            return nil
    }
    return novaGroup
}

private func getEnvironmentalImpaceImage(from product: Product) -> UIImage? {
    guard let co2Impact = product.environmentImpactLevelTags?.first else {
        return nil
    }
    return co2Impact.image
}

// MARK: - OfflineProduct
private func getBrands(from product: RealmOfflineProduct) -> String? {
    guard let brands = product.brands,
        !brands.isEmpty else {
            return nil
    }
    return brands
}

private func getQuantity(from product: RealmOfflineProduct) -> String? {
    guard let quantity = product.quantity,
        !quantity.isEmpty else {
            return nil
    }
    return quantity
}

private func getNutriScore(from product: RealmOfflineProduct) -> NutriScoreView.Score? {
    guard let nutriscoreValue = product.nutritionGrade,
        let score = NutriScoreView.Score(rawValue: nutriscoreValue) else {
            return nil
    }
    return score
}

private func getNovaGroup(from product: RealmOfflineProduct) -> NovaGroupView.NovaGroup? {
    guard let novaGroupValue = product.novaGroup,
        let novaIntValue = Double(novaGroupValue),
        let novaGroup = NovaGroupView.NovaGroup(rawValue: "\(Int(novaIntValue))") else {
            return nil
    }
    return novaGroup
}
