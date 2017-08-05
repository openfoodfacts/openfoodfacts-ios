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
//        vcs.append(getNutritionVC())
//        vcs.append(getNutritionTableVC())

        return vcs
    }

    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func getSummaryVC() -> UIViewController {
        var sections = [FormSection]()

        // Header
        sections.append(FormSection(rows: [FormRow(value: product, cellType: HostedViewCell.self)]))

        // Rows
        var rows = [FormRow]()

        createFormRow(with: &rows, item: product.barcode, label: InfoRowKey.barcode.localizedString)
        createFormRow(with: &rows, item: product.quantity, label: InfoRowKey.quantity.localizedString)
        createFormRow(with: &rows, item: product.packaging, label: InfoRowKey.packaging.localizedString)
        createFormRow(with: &rows, item: product.brands, label: InfoRowKey.brands.localizedString)
        createFormRow(with: &rows, item: product.manufacturingPlaces, label: InfoRowKey.manufacturingPlaces.localizedString)
        createFormRow(with: &rows, item: product.origins, label: InfoRowKey.origins.localizedString)
        createFormRow(with: &rows, item: product.categories, label: InfoRowKey.categories.localizedString)
        createFormRow(with: &rows, item: product.labels, label: InfoRowKey.labels.localizedString)
        createFormRow(with: &rows, item: product.citiesTags, label: InfoRowKey.citiesTags.localizedString)
        createFormRow(with: &rows, item: product.stores, label: InfoRowKey.stores.localizedString)
        createFormRow(with: &rows, item: product.countries, label: InfoRowKey.countries.localizedString)

        sections.append(FormSection(rows: rows))

        let summaryTitle = NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary")

        return SummaryFormTableViewController(with: Form(title: summaryTitle, sections: sections))
    }

    fileprivate func createFormRow(with array: inout [FormRow], item: Any?, label: String, cellType: ProductDetailBaseCell.Type = InfoRowTableViewCell.self) {
        if let value = item as? String, !value.isEmpty {
            array.append(FormRow(label: label, value: value, cellType: cellType))
        } else if let value = item as? [String], !value.isEmpty {
            array.append(FormRow(label: label, value: value, cellType: cellType))
        }
    }

    fileprivate func getIngredientsVC() -> UIViewController {
        var sections = [FormSection]()

        // Header
        sections.append(FormSection(rows: [FormRow(value: product, cellType: HostedViewCell.self)]))

        // Rows
        var rows = [FormRow]()

        createFormRow(with: &rows, item: product.ingredientsList, label: InfoRowKey.ingredientsList.localizedString)
        createFormRow(with: &rows, item: product.allergens, label: InfoRowKey.allergens.localizedString)
        createFormRow(with: &rows, item: product.traces, label: InfoRowKey.traces.localizedString)
        createFormRow(with: &rows, item: product.additives?.map({ $0.value.uppercased() }), label: InfoRowKey.additives.localizedString)
        createFormRow(with: &rows, item: product.palmOilIngredients, label: InfoRowKey.palmOilIngredients.localizedString)
        createFormRow(with: &rows, item: product.possiblePalmOilIngredients, label: InfoRowKey.possiblePalmOilIngredients.localizedString)

        sections.append(FormSection(rows: rows))

        let summaryTitle = NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")

        return IngredientsFormTableViewController(with: Form(title: summaryTitle, sections: sections))
    }

    fileprivate func getNutritionVC() -> UIViewController {
        return UIViewController()
//        let nutritionTitle = NSLocalizedString("product-detail.page-title.nutrition", comment: "Product detail, nutrition")
//
//        var nutritionInfoRows = [InfoRow]()
//
//        if let servingSize = product.servingSize, !servingSize.isEmpty {
//            nutritionInfoRows.append(InfoRow(label: .servingSize, value: servingSize))
//        }
//        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
//            nutritionInfoRows.append(InfoRow(label: .carbonFootprint, value:(String(carbonFootprint) + " " + unit)))
//        }
//
//        return ProductNutritionViewController(product: product, localizedTitle: nutritionTitle, infoRows: nutritionInfoRows)
    }

    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func getNutritionTableVC() -> UIViewController {
        return UIViewController()
//        let nutritionTableTitle = NSLocalizedString("product-detail.page-title.nutrition-table", comment: "Product detail, nutrition table")
//        var nutritionTableInfoRows = [InfoRow]()
//
//        let headerRow = InfoRow(label: .nutritionalTableHeader, value: NSLocalizedString("product-detail.nutrition-table.for-100g", comment: ""),
//                                secondaryValue: NSLocalizedString("product-detail.nutrition-table.for-serving", comment: ""))
//
//        nutritionTableInfoRows.append(headerRow)
//
//        if let energy = product.nutriments?.energy, let infoRow = energy.asInfoRow {
//            nutritionTableInfoRows.append(infoRow)
//        }
//        if let fats = product.nutriments?.fats {
//            for item in fats {
//                if let infoRow = item.asInfoRow {
//                    nutritionTableInfoRows.append(infoRow)
//                }
//            }
//        }
//        if let carbohydrates = product.nutriments?.carbohydrates {
//            for item in carbohydrates {
//                if let infoRow = item.asInfoRow {
//                    nutritionTableInfoRows.append(infoRow)
//                }
//            }
//        }
//        if let fiber = product.nutriments?.fiber, let infoRow = fiber.asInfoRow {
//            nutritionTableInfoRows.append(infoRow)
//        }
//        if let proteins = product.nutriments?.proteins {
//            for item in proteins {
//                if let infoRow = item.asInfoRow {
//                    nutritionTableInfoRows.append(infoRow)
//                }
//            }
//        }
//        if let salt = product.nutriments?.salt, let infoRow = salt.asInfoRow {
//            nutritionTableInfoRows.append(infoRow)
//        }
//        if let sodium = product.nutriments?.sodium, let infoRow = sodium.asInfoRow {
//            nutritionTableInfoRows.append(infoRow)
//        }
//        if let alcohol = product.nutriments?.alcohol, let infoRow = alcohol.asInfoRow {
//            nutritionTableInfoRows.append(infoRow)
//        }
//        if let vitamins = product.nutriments?.vitamins {
//            for item in vitamins {
//                if let infoRow = item.asInfoRow {
//                    nutritionTableInfoRows.append(infoRow)
//                }
//            }
//        }
//        if let minerals = product.nutriments?.minerals {
//            for item in minerals {
//                if let infoRow = item.asInfoRow {
//                    nutritionTableInfoRows.append(infoRow)
//                }
//            }
//        }
//
//        return ProductDetailPageViewController<NutritionTableHeaderTableViewCell, NutritionTableRowTableViewCell>(product: product,
//                                                                                                                  localizedTitle: nutritionTableTitle,
//                                                                                                                  infoRows: nutritionTableInfoRows)
    }
}
