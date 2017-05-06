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
        
        let summaryTitle = NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary")
        let ingredientsTitle = NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")
        
        let summaryInfoRows: [(String?, InfoRowKey)] = [(product.barcode, .barcode),
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
        let ingredientsInfoRows: [(String?, InfoRowKey)] = [(product.ingredientsList, .ingredientsList),
                                                            (product.allergens, .allergens),
                                                            (product.traces, .traces),
                                                            (product.additives?.map({ $0.value.uppercased() }).joined(separator: ", "), .additives),
                                                            (product.palmOilIngredients.joined(separator: ", "), .palmOilIngredients),
                                                            (product.possiblePalmOilIngredients.joined(separator: ", "), .possiblePalmOilIngredients)]
        
        let summaryVC = ProductDetailPageViewController<SummaryHeaderTableViewCell, SummaryRowTableViewCell>(product: product, localizedTitle: summaryTitle, infoRowList: summaryInfoRows)
        let ingredientsVC = ProductDetailPageViewController<SummaryHeaderTableViewCell, SummaryRowTableViewCell>(product: product, localizedTitle: ingredientsTitle, infoRowList: ingredientsInfoRows)
        
        vcs.append(summaryVC)
        vcs.append(ingredientsVC)
        
        if let nutrition = UIStoryboard(name: String(describing: ProductNutritionViewController.self), bundle: nil).instantiateInitialViewController() as? ProductNutritionViewController {
            vcs.append(nutrition)
        }
        
        return vcs
    }
}
