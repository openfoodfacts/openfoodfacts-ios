//
//  ProductDetailViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Crashlytics

class ProductDetailViewController: ButtonBarPagerTabStripViewController {
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBarView.register(UINib(nibName: "ButtonBarView", bundle: nil), forCellWithReuseIdentifier: "Cell")
        buttonBarView.backgroundColor = .white
        settings.style.selectedBarBackgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = self.view.tintColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Answers.logContentView(withName: "Product's detail", contentType: "product_detail", contentId: product.barcode, customAttributes: ["product_name": product.name ?? ""])
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()
        
        vcs.append(getSummaryVC())
        vcs.append(getIngredientsVC())
        vcs.append(getNutritionVC())
        vcs.append(getNutritionTableVC())
        
        return vcs
    }
    
    fileprivate func getSummaryVC() -> UIViewController {
        let summaryTitle = NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary")
        
        var summaryInfoRows = [InfoRow]()
        
        if let barcode = product.barcode, !barcode.isEmpty {
            summaryInfoRows.append(InfoRow(label: .barcode, value: barcode))
        }
        if let quantity = product.quantity, !quantity.isEmpty {
            summaryInfoRows.append(InfoRow(label: .quantity, value: quantity))
        }
        if let array = product.packaging, !array.isEmpty {
            summaryInfoRows.append(InfoRow(label: .packaging, value: array.joined(separator: ", ")))
        }
        if let array = product.brands, !array.isEmpty {
            summaryInfoRows.append(InfoRow(label: .brands, value: array.joined(separator: ", ")))
        }
        if let manufacturingPlaces = product.manufacturingPlaces, !manufacturingPlaces.isEmpty {
            summaryInfoRows.append(InfoRow(label: .manufacturingPlaces, value: manufacturingPlaces))
        }
        if let origins = product.origins, !origins.isEmpty {
            summaryInfoRows.append(InfoRow(label: .origins, value: origins))
        }
        if let array = product.categories, !array.isEmpty {
            summaryInfoRows.append(InfoRow(label: .categories, value: array.joined(separator: ", ")))
        }
        if let array = product.labels, !array.isEmpty {
            summaryInfoRows.append(InfoRow(label: .labels, value: array.joined(separator: ", ")))
        }
        if let citiesTags = product.citiesTags, !citiesTags.isEmpty {
            summaryInfoRows.append(InfoRow(label: .citiesTags, value: citiesTags))
        }
        if let array = product.stores, !array.isEmpty {
            summaryInfoRows.append(InfoRow(label: .stores, value: array.joined(separator: ", ")))
        }
        if let array = product.countries, !array.isEmpty {
            summaryInfoRows.append(InfoRow(label: .countries, value: array.joined(separator: ", ")))
        }
        
        return ProductDetailPageViewController<SummaryHeaderTableViewCell, InfoRowTableViewCell>(product: product, localizedTitle: summaryTitle, infoRows: summaryInfoRows)
    }
    
    fileprivate func getIngredientsVC() -> UIViewController {
        let ingredientsTitle = NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")
        
        var ingredientsInfoRows = [InfoRow]()
        
        if let ingredientsList = product.ingredientsList, !ingredientsList.isEmpty {
            ingredientsInfoRows.append(InfoRow(label: .ingredientsList, value: ingredientsList))
        }
        if let allergens = product.allergens, !allergens.isEmpty {
            ingredientsInfoRows.append(InfoRow(label: .allergens, value: allergens))
        }
        if let traces = product.traces, !traces.isEmpty {
            ingredientsInfoRows.append(InfoRow(label: .traces, value: traces))
        }
        if let additives = product.additives?.map({ $0.value.uppercased() }).joined(separator: ", "), !additives.isEmpty {
            ingredientsInfoRows.append(InfoRow(label: .additives, value: additives))
        }
        if let array = product.palmOilIngredients, !array.isEmpty {
            ingredientsInfoRows.append(InfoRow(label: .palmOilIngredients, value: array.joined(separator: ", ")))
        }
        if let array = product.possiblePalmOilIngredients, !array.isEmpty {
            ingredientsInfoRows.append(InfoRow(label: .possiblePalmOilIngredients, value: array.joined(separator: ", ")))
        }
        
        return ProductDetailPageViewController<IngredientHeaderTableViewCell, InfoRowTableViewCell>(product: product, localizedTitle: ingredientsTitle, infoRows: ingredientsInfoRows)
    }
    
    fileprivate func getNutritionVC() -> UIViewController {
        let nutritionTitle = NSLocalizedString("product-detail.page-title.nutrition", comment: "Product detail, nutrition")
        
        var nutritionInfoRows = [InfoRow]()
        
        if let servingSize = product.servingSize, !servingSize.isEmpty {
            nutritionInfoRows.append(InfoRow(label: .servingSize, value: servingSize))
        }
        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
            nutritionInfoRows.append(InfoRow(label: .carbonFootprint, value:(String(carbonFootprint) + " " + unit)))
        }
        
        return ProductNutritionViewController(product: product, localizedTitle: nutritionTitle, infoRows: nutritionInfoRows)
    }
    
    fileprivate func getNutritionTableVC() -> UIViewController {
        let nutritionTableTitle = NSLocalizedString("product-detail.page-title.nutrition-table", comment: "Product detail, nutrition table")
        var nutritionTableInfoRows = [InfoRow]()
        
        nutritionTableInfoRows.append(InfoRow(label: .nutritionalTableHeader, value: NSLocalizedString("product-detail.nutrition-table.for-100g", comment: ""), secondaryValue: NSLocalizedString("product-detail.nutrition-table.for-serving", comment: "")))
        
        if let energy = product.nutriments?.energy, let infoRow = energy.asInfoRow {
            nutritionTableInfoRows.append(infoRow)
        }
        if let fats = product.nutriments?.fats {
            for item in fats {
                if let infoRow = item.asInfoRow {
                    nutritionTableInfoRows.append(infoRow)
                }
            }
        }
        if let carbohydrates = product.nutriments?.carbohydrates {
            for item in carbohydrates {
                if let infoRow = item.asInfoRow {
                    nutritionTableInfoRows.append(infoRow)
                }
            }
        }
        if let fiber = product.nutriments?.fiber, let infoRow = fiber.asInfoRow {
            nutritionTableInfoRows.append(infoRow)
        }
        if let proteins = product.nutriments?.proteins {
            for item in proteins {
                if let infoRow = item.asInfoRow {
                    nutritionTableInfoRows.append(infoRow)
                }
            }
        }
        if let salt = product.nutriments?.salt, let infoRow = salt.asInfoRow {
            nutritionTableInfoRows.append(infoRow)
        }
        if let sodium = product.nutriments?.sodium, let infoRow = sodium.asInfoRow {
            nutritionTableInfoRows.append(infoRow)
        }
        if let alcohol = product.nutriments?.alcohol, let infoRow = alcohol.asInfoRow {
            nutritionTableInfoRows.append(infoRow)
        }
        if let vitamins = product.nutriments?.vitamins {
            for item in vitamins {
                if let infoRow = item.asInfoRow {
                    nutritionTableInfoRows.append(infoRow)
                }
            }
        }
        if let minerals = product.nutriments?.minerals {
            for item in minerals {
                if let infoRow = item.asInfoRow {
                    nutritionTableInfoRows.append(infoRow)
                }
            }
        }
        
        return ProductDetailPageViewController<NutritionTableHeaderTableViewCell, NutritionTableRowTableViewCell>(product: product, localizedTitle: nutritionTableTitle, infoRows: nutritionTableInfoRows)
    }
}
