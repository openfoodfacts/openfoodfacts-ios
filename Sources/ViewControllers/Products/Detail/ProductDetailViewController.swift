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

class ProductDetailViewController: ButtonBarPagerTabStripViewController, DataManagerClient {

    var product: Product!
    var dataManager: DataManagerProtocol!

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
        if var buttons = navigationItem.rightBarButtonItems, buttons.count == 1 {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton(_:)))
            buttons.insert(editButton, at: 0)
            navigationItem.rightBarButtonItems = buttons
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isTranslucent = true
        if var buttons = navigationItem.rightBarButtonItems, buttons.count == 2 {
            buttons.remove(at: 0)
            navigationItem.rightBarButtonItems = buttons
        }
    }

    // MARK: - Product pages

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()

        vcs.append(getSummaryVC())
        vcs.append(getIngredientsVC())
        if let nutritionVC = getNutritionVC() {
            vcs.append(nutritionVC)
        }
        vcs.append(getNutritionTableVC())

        return vcs
    }

    fileprivate func getSummaryVC() -> UIViewController {
        let form = createSummaryForm()
        let vc = SummaryFormTableViewController(with: form, dataManager: dataManager)
        vc.delegate = self
        return vc
    }

    fileprivate func getIngredientsVC() -> UIViewController {
        let form = createIngredientsForm()
        let vc = IngredientsFormTableViewController(with: form, dataManager: dataManager)
        vc.delegate = self
        return vc
    }

    fileprivate func getNutritionVC() -> UIViewController? {
        guard let form = createNutritionForm() else { return nil }
        let vc = FormTableViewController(with: form, dataManager: dataManager)
        vc.delegate = self
        return vc
    }

    fileprivate func getNutritionTableVC() -> UIViewController {
        let form = createNutritionTableForm()
        let vc = NutritionTableFormTableViewController(with: form, dataManager: dataManager)
        vc.delegate = self
        return vc
    }

    // MARK: - Form creation methods

    private func updateForms(with updatedProduct: Product) {
        self.product = updatedProduct

        if let viewControllers = self.viewControllers as? [FormTableViewController] {
            viewControllers[0].form = createSummaryForm()
            viewControllers[1].form = createIngredientsForm()

            if viewControllers.count == 3 {
                viewControllers[2].form = createNutritionTableForm()
            } else {
                viewControllers[2].form = createNutritionForm()
                viewControllers[3].form = createNutritionTableForm()
            }
        }
    }

    private func createSummaryForm() -> Form {
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

        let summaryTitle = "product-detail.page-title.summary".localized

        return Form(title: summaryTitle, rows: rows)
    }

    private func createIngredientsForm() -> Form {
        var rows = [FormRow]()

        // Header
        rows.append(FormRow(value: product, cellType: HostedViewCell.self))

        // Rows
        createFormRow(with: &rows, item: product.ingredientsList, label: InfoRowKey.ingredientsList.localizedString)
        createFormRow(with: &rows, item: product.allergens?.map({ $0.value.capitalized }), label: InfoRowKey.allergens.localizedString)
        createFormRow(with: &rows, item: product.traces, label: InfoRowKey.traces.localizedString)
        createFormRow(with: &rows, item: product.additives?.map({ $0.value.uppercased() }), label: InfoRowKey.additives.localizedString)
        createFormRow(with: &rows, item: product.palmOilIngredients, label: InfoRowKey.palmOilIngredients.localizedString)
        createFormRow(with: &rows, item: product.possiblePalmOilIngredients, label: InfoRowKey.possiblePalmOilIngredients.localizedString)

        let summaryTitle = "product-detail.page-title.ingredients".localized

        return Form(title: summaryTitle, rows: rows)
    }

    private func createNutritionForm() -> Form? {
        var rows = [FormRow]()

        // Nutriscore cell
        if product.nutriscore != nil {
            createFormRow(with: &rows, item: product.nutriscore, cellType: NutritionHeaderTableViewCell.self)
        }

        // Info rows
        if product.servingSize != nil {
            createFormRow(with: &rows, item: product.servingSize, label: InfoRowKey.servingSize.localizedString)
        }

        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
            createFormRow(with: &rows, item: "\(carbonFootprint) \(unit)", label: InfoRowKey.carbonFootprint.localizedString)
        }

        // Nutrition levels
        if product.nutritionLevels != nil {
            createFormRow(with: &rows, item: product, cellType: NutritionLevelsTableViewCell.self)
        }

        if rows.isEmpty {
            return nil
        }

        let summaryTitle = "product-detail.page-title.nutrition".localized

        return Form(title: summaryTitle, rows: rows)
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func createNutritionTableForm() -> Form {
        var rows = [FormRow]()

        // Header
        createFormRow(with: &rows, item: product, cellType: HostedViewCell.self)

        // Nutrition table rows
        let headerRow = NutritionTableRow(label: InfoRowKey.nutritionalTableHeader.localizedString,
                                          perSizeValue: "product-detail.nutrition-table.for-100g".localized,
                                          perServingValue: "product-detail.nutrition-table.for-serving".localized)
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

        let summaryTitle = "product-detail.page-title.nutrition-table".localized

        return Form(title: summaryTitle, rows: rows)
    }

    private func createFormRow(with array: inout [FormRow], item: Any?, label: String? = nil, cellType: ProductDetailBaseCell.Type = InfoRowTableViewCell.self, isCopiable: Bool = false) {
        // Check item has a value, if so add to the array of rows.
        if label == InfoRowKey.additives.localizedString {
            print("here where label = InfoRowKey.additives.localizedString")
            switch item {
            case let value as String:
                // Check if it's empty here insted of doing 'case let value as String where !value.isEmpty' because an empty String ("") would not match this case but the default one
                if !value.isEmpty {
                    array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
                }
            case var value as [Any]:
                for index in 0 ..< value.count {
                    if let anyObjectToString = value[index] as? String {
                        let enumberCodeConvertedToString = anyObjectToString.localized
                        if index == 0 {
                            //check the case where the additive e-code is not included in the localizable string file
                            if enumberCodeConvertedToString == anyObjectToString {
                                value[index] = "\n\u{2022} " + anyObjectToString + "\n"
                            } else {
                            value[index] = "\n\u{2022} " + anyObjectToString + " - " + anyObjectToString.localized + "\n"
                            }
                        } else if index == (value.count - 1) {
                            //check the case where the additive e-code is not included in the localizable string file
                            if enumberCodeConvertedToString == anyObjectToString {
                                value[index] = "\u{2022} " + anyObjectToString
                            } else {
                            value[index] = "\u{2022} " + anyObjectToString + " - " + anyObjectToString.localized
                            }
                        } else {
                            //check the case where the additive e-code is not included in the localizable string file
                            if enumberCodeConvertedToString == anyObjectToString {
                                value[index] = "\u{2022} " + anyObjectToString + "\n"
                            } else {
                            value[index] = "\u{2022} " + anyObjectToString + " - " + anyObjectToString.localized + "\n"
                            }
                        }
                    } else {
                        print("Error, was not a string")
                    }
                }
                if !value.isEmpty {
                    array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
                }
            default:
                if let value = item {
                    print(value)
                    array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
                }
            }
        }
        else {
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
                    print(value)
                    array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable))
                }
            }
        }
    }

    // MARK: - Nav bar button

    @objc func didTapEditButton(_ sender: UIBarButtonItem) {
        if let barcode = self.product?.barcode, let url = URL(string: URLs.Edit + barcode) {
            openUrlInApp(url, showAlert: true)
        }
    }
}

// MARK: - Refresh delegate

protocol ProductDetailRefreshDelegate: class {
    func refreshProduct(completion: () -> Void)
}

extension ProductDetailViewController: ProductDetailRefreshDelegate {
    func refreshProduct(completion: () -> Void) {
        if let barcode = product.barcode {
            dataManager.getProduct(byBarcode: barcode, isScanning: false, onSuccess: { response in
                if let updatedProduct = response {
                    self.updateForms(with: updatedProduct)
                }
            }, onError: { error in
                // No error should be thrown here, as the product was loaded previously
                Crashlytics.sharedInstance().recordError(error)
                self.navigationController?.popToRootViewController(animated: true)
            })
        }

        completion()
    }
}
