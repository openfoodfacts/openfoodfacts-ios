//
//  ProductDetailViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

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
        
        let summaryInfoRows: [(Any?, InfoRowKey)] = [(product.barcode, .barcode),
                                                     (product.quantity, .quantity),
                                                     (product.packaging.joined(separator: ", "), .packaging),
                                                     (product.brands.joined(separator: ", "), .brands),
                                                     (product.manufacturingPlaces, .manufacturingPlaces),
                                                     (product.origins, .origins),
                                                     (product.categories.joined(separator: ", "), .categories),
                                                     (product.labels.joined(separator: ", "), .labels),
                                                     (product.citiesTags, .citiesTags),
                                                     (product.stores.joined(separator: ", "), .stores),
                                                     (product.countries.joined(separator: ", "), .countries)]
        
        
        return ProductDetailPageViewController<SummaryHeaderTableViewCell, InfoRowTableViewCell>(product: product, localizedTitle: summaryTitle, infoRowList: summaryInfoRows)
    }
    
    fileprivate func getIngredientsVC() -> UIViewController {
        let ingredientsTitle = NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")
        
        let ingredientsInfoRows: [(Any?, InfoRowKey)] = [(product.ingredientsList, .ingredientsList),
                                                         (product.allergens, .allergens),
                                                         (product.traces, .traces),
                                                         (product.additives?.map({ $0.value.uppercased() }).joined(separator: ", "), .additives),
                                                         (product.palmOilIngredients.joined(separator: ", "), .palmOilIngredients),
                                                         (product.possiblePalmOilIngredients.joined(separator: ", "), .possiblePalmOilIngredients)]
        
        return ProductDetailPageViewController<IngredientHeaderTableViewCell, InfoRowTableViewCell>(product: product, localizedTitle: ingredientsTitle, infoRowList: ingredientsInfoRows)
    }
    
    fileprivate func getNutritionVC() -> UIViewController {
        let nutritionTitle = NSLocalizedString("product-detail.page-title.nutrition", comment: "Product detail, nutrition")
        
        var nutritionInfoRows: [(Any?, InfoRowKey)] = [(product.servingSize, .servingSize)]
        
        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
            nutritionInfoRows.append(((String(carbonFootprint) + " " + unit), .carbonFootprint))
        }
        
        return ProductNutritionViewController(product: product, localizedTitle: nutritionTitle, infoRowList: nutritionInfoRows)
    }
    
    fileprivate func getNutritionTableVC() -> UIViewController {
        let nutritionTableTitle = NSLocalizedString("product-detail.page-title.nutrition-table", comment: "Product detail, nutrition table")
        
        let nutritionTableInfoRows: [(Any?, InfoRowKey)] = [
            // TODO Build InfoRows here, for this and the other VCs
            ([String(product.nutriments!.energy!.per100g!), product.nutriments!.energy!.perServing!], .energy)
        ]
        
        return ProductDetailPageViewController<NutritionTableHeaderTableViewCell, NutritionTableRowTableViewCell>(product: product, localizedTitle: nutritionTableTitle, infoRowList: nutritionTableInfoRows)
    }
}
