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
    var productApi: ProductApi!

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

    // MARK: - Product pages

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()

        vcs.append(getSummaryVC())
        vcs.append(getIngredientsVC())
        vcs.append(getNutritionVC())
        vcs.append(getNutritionTableVC())

        return vcs
    }

    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func getSummaryVC() -> UIViewController {
        var rows = [FormRow]()

        // Header
        rows.append(FormRow(value: product, cellType: HostedViewCell.self))

        // Rows
        createFormRow(with: &rows, item: product.barcode, label: InfoRowKey.barcode.localizedString, isCopiable: true)
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

        let summaryTitle = NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary")

        return SummaryFormTableViewController(with: Form(title: summaryTitle, rows: rows), productApi: productApi)
    }

    fileprivate func getIngredientsVC() -> UIViewController {
        var rows = [FormRow]()

        // Header
        rows.append(FormRow(value: product, cellType: HostedViewCell.self))

        // Rows
        createFormRow(with: &rows, item: product.ingredientsList, label: InfoRowKey.ingredientsList.localizedString)
        createFormRow(with: &rows, item: product.allergens, label: InfoRowKey.allergens.localizedString)
        createFormRow(with: &rows, item: product.traces, label: InfoRowKey.traces.localizedString)
        createFormRow(with: &rows, item: product.additives?.map({ $0.value.uppercased() }), label: InfoRowKey.additives.localizedString)
        createFormRow(with: &rows, item: product.palmOilIngredients, label: InfoRowKey.palmOilIngredients.localizedString)
        createFormRow(with: &rows, item: product.possiblePalmOilIngredients, label: InfoRowKey.possiblePalmOilIngredients.localizedString)

        let summaryTitle = NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")

        return IngredientsFormTableViewController(with: Form(title: summaryTitle, rows: rows), productApi: productApi)
    }

    fileprivate func getNutritionVC() -> UIViewController {
        var rows = [FormRow]()

        // Nutriscore cell
        createFormRow(with: &rows, item: product.nutriscore, cellType: NutritionHeaderTableViewCell.self)

        // Info rows
        createFormRow(with: &rows, item: product.servingSize, label: InfoRowKey.servingSize.localizedString)
        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
            createFormRow(with: &rows, item: "\(carbonFootprint) \(unit)", label: InfoRowKey.carbonFootprint.localizedString)
        }

        // Nutrition levels
        createFormRow(with: &rows, item: product, cellType: NutritionLevelsTableViewCell.self)

        let summaryTitle = NSLocalizedString("product-detail.page-title.nutrition", comment: "Product detail, nutrition")

        return FormTableViewController(with: Form(title: summaryTitle, rows: rows), productApi: productApi)
    }

    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func getNutritionTableVC() -> UIViewController {
        var rows = [FormRow]()

        // Header
        createFormRow(with: &rows, item: product, cellType: HostedViewCell.self)

        // Nutrition table rows
        let headerRow = NutritionTableRow(label: InfoRowKey.nutritionalTableHeader.localizedString,
                                          perSizeValue: NSLocalizedString("product-detail.nutrition-table.for-100g", comment: ""),
                                          perServingValue: NSLocalizedString("product-detail.nutrition-table.for-serving", comment: ""))
        createFormRow(with: &rows, item: headerRow, cellType: NutritionTableRowTableViewCell.self)

        if let energy = product.nutriments?.energy, let nutritionTableRow = energy.nutritionTableRow {
            createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
        }
        if let fats = product.nutriments?.fats {
            for item in fats {
                if let nutritionTableRow = item.nutritionTableRow {
                    createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
                }
            }
        }
        if let carbohydrates = product.nutriments?.carbohydrates {
            for item in carbohydrates {
                if let nutritionTableRow = item.nutritionTableRow {
                    createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
                }
            }
        }
        if let fiber = product.nutriments?.fiber, let nutritionTableRow = fiber.nutritionTableRow {
            createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
        }
        if let proteins = product.nutriments?.proteins {
            for item in proteins {
                if let nutritionTableRow = item.nutritionTableRow {
                    createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
                }
            }
        }
        if let salt = product.nutriments?.salt, let nutritionTableRow = salt.nutritionTableRow {
            createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
        }
        if let sodium = product.nutriments?.sodium, let nutritionTableRow = sodium.nutritionTableRow {
            createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
        }
        if let alcohol = product.nutriments?.alcohol, let nutritionTableRow = alcohol.nutritionTableRow {
            createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
        }
        if let vitamins = product.nutriments?.vitamins {
            for item in vitamins {
                if let nutritionTableRow = item.nutritionTableRow {
                    createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
                }
            }
        }
        if let minerals = product.nutriments?.minerals {
            for item in minerals {
                if let nutritionTableRow = item.nutritionTableRow {
                    createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
                }
            }
        }

        let summaryTitle = NSLocalizedString("product-detail.page-title.nutrition-table", comment: "Product detail, nutrition table")

        return NutritionTableFormTableViewController(with: Form(title: summaryTitle, rows: rows), productApi: productApi)
    }

    fileprivate func createFormRow(with array: inout [FormRow], item: Any?, label: String? = nil, cellType: ProductDetailBaseCell.Type = InfoRowTableViewCell.self,
                                   isCopiable: Bool = false) {
        // Check item has a value, if so add to the array of rows.
        switch item {
        case let value as String:
            // Check if it's empty here insted of doing 'case let value as String where !value.isEmpty' because an empty String ("") would not match this case but the default one
            if !value.isEmpty {
                array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
            }
        case let value as [Any]:
            if !value.isEmpty {
                array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
            }
        default:
            if let value = item {
                array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
            }
        }
    }

    // MARK: - Nav bar button

    @IBAction func didTapScanButton(_ sender: UIBarButtonItem) {
        let scanVC = ScannerViewController(productApi: productApi)
        navigationController?.pushViewController(scanVC, animated: true)
    }
}
