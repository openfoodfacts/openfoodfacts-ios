//
//  ProductDetailViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 24/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import XLPagerTabStrip
import ObjectMapper

// swiftlint:disable force_cast
class ProductDetailViewControllerTests: XCTestCase {
    var viewController: ProductDetailViewController!
    var navigationController: UINavigationControllerMock!
    var productApi: ProductServiceMock!
    var pagerTabStripController: PagerTabStripViewController!

    private let tintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    private let productFile = "Product_fanta_orange"

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: String(describing: ProductDetailViewController.self), bundle: Bundle.main)
        viewController = storyboard.instantiateInitialViewController() as! ProductDetailViewController
        navigationController = UINavigationControllerMock(rootViewController: viewController)

        productApi = ProductServiceMock()
        viewController.productApi = productApi
        viewController.product = Product()

        pagerTabStripController = PagerTabStripViewController()

        UIApplication.shared.keyWindow!.rootViewController = navigationController

        expect(self.navigationController.view).toNot(beNil())
        expect(self.viewController.view).toNot(beNil())
        expect(self.viewController.navigationController).toEventuallyNot(beNil())
    }

    // MARK: - viewDidLoad
    func testAfterViewDidLoadButtonBarPagerTabStripIsSetup() {
        viewController.viewDidLoad()

        expect(self.viewController.buttonBarView.backgroundColor).to(equal(.white))
        expect(self.viewController.settings.style.selectedBarBackgroundColor).to(equal(UIColor.white))
        expect(self.viewController.buttonBarView.selectedBar.backgroundColor).to(equal(self.tintColor))
    }

    // MARK: - viewWillAppear
    func testAfterViewWillAppearNavBarShouldNotBeTranslucen() {
        viewController.viewWillAppear(false)

        expect(self.navigationController.navigationBar.isTranslucent).toEventually(beFalse())
    }

    // MARK: - viewWillDisappear
    func testAfterViewWillDisappearNavBarShouldBeTranslucent() {
        viewController.viewWillDisappear(false)

        expect(self.navigationController.navigationBar.isTranslucent).toEventually(beTrue())
    }

    // MARK: - viewControllers
    // swiftlint:disable:next function_body_length
    func testViewControllersCreatesAllPagesWhenProductIsComplete() {
        let product = buildProductForJsonFile(productFile)
        viewController.product = product

        let viewControllers = viewController.viewControllers(for: pagerTabStripController)

        expect(viewControllers[0] is SummaryFormTableViewController).to(beTrue())
        expect(viewControllers[1] is IngredientsFormTableViewController).to(beTrue())
        expect(viewControllers[2] is FormTableViewController).to(beTrue())
        expect(viewControllers[3] is NutritionTableFormTableViewController).to(beTrue())

        let summaryVC = viewControllers[0] as! SummaryFormTableViewController
        var form = summaryVC.form
        var rows = form.rows

        // There should be a better way to assert all this... but how? 🤔

        expect(form.title).to(equal(NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary")))
        expect(rows[0].label).to(beNil())
        expect(rows[0].cellType == HostedViewCell.self).to(beTrue())
        expect(rows[0].isCopiable).to(beFalse())
        expect(rows[1].label).to(equal(InfoRowKey.barcode.localizedString))
        expect(rows[1].value as? String).to(equal(product.barcode))
        expect(rows[1].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[1].isCopiable).to(beTrue())
        expect(rows[2].label).to(equal(InfoRowKey.quantity.localizedString))
        expect(rows[2].value as? String).to(equal(product.quantity))
        expect(rows[2].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[3].label).to(equal(InfoRowKey.packaging.localizedString))
        expect(rows[3].value as? [String]).to(equal(product.packaging))
        expect(rows[3].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[4].label).to(equal(InfoRowKey.brands.localizedString))
        expect(rows[4].value as? [String]).to(equal(product.brands))
        expect(rows[4].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[5].label).to(equal(InfoRowKey.manufacturingPlaces.localizedString))
        expect(rows[5].value as? String).to(equal(product.manufacturingPlaces))
        expect(rows[5].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[6].label).to(equal(InfoRowKey.origins.localizedString))
        expect(rows[6].value as? String).to(equal(product.origins))
        expect(rows[6].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[7].label).to(equal(InfoRowKey.categories.localizedString))
        expect(rows[7].value as? [String]).to(equal(product.categories))
        expect(rows[7].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[8].label).to(equal(InfoRowKey.labels.localizedString))
        expect(rows[8].value as? [String]).to(equal(product.labels))
        expect(rows[8].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[9].label).to(equal(InfoRowKey.citiesTags.localizedString))
        expect(rows[9].value as? [String]).to(equal(product.citiesTags))
        expect(rows[9].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[10].label).to(equal(InfoRowKey.stores.localizedString))
        expect(rows[10].value as? [String]).to(equal(product.stores))
        expect(rows[10].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[11].label).to(equal(InfoRowKey.countries.localizedString))
        expect(rows[11].value as? [String]).to(equal(product.countries))
        expect(rows[11].cellType == InfoRowTableViewCell.self).to(beTrue())

        let ingredientsVC = viewControllers[1] as! IngredientsFormTableViewController
        form = ingredientsVC.form
        rows = form.rows

        expect(form.title).to(equal(NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")))
        expect(rows[0].label).to(beNil())
        expect(rows[0].cellType == HostedViewCell.self).to(beTrue())
        expect(rows[0].isCopiable).to(beFalse())
        expect(rows[1].label).to(equal(InfoRowKey.ingredientsList.localizedString))
        expect(rows[1].value as? String).to(equal(product.ingredientsList))
        expect(rows[1].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[2].label).to(equal(InfoRowKey.allergens.localizedString))
        expect((rows[2].value as! [String])[0]).to(equal(product.allergens![0].value.capitalized))
        expect((rows[2].value as! [String])[1]).to(equal(product.allergens![1].value.capitalized))
        expect(rows[2].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[3].label).to(equal(InfoRowKey.traces.localizedString))
        expect(rows[3].value as? String).to(equal(product.traces))
        expect(rows[3].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[4].label).to(equal(InfoRowKey.additives.localizedString))
        expect((rows[4].value as! [String])[0]).to(equal(product.additives![0].value.uppercased()))
        expect((rows[4].value as! [String])[1]).to(equal(product.additives![1].value.uppercased()))
        expect(rows[4].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[5].label).to(equal(InfoRowKey.palmOilIngredients.localizedString))
        expect(rows[5].value as? [String]).to(equal(product.palmOilIngredients))
        expect(rows[5].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[6].label).to(equal(InfoRowKey.possiblePalmOilIngredients.localizedString))
        expect(rows[6].value as? [String]).to(equal(product.possiblePalmOilIngredients))
        expect(rows[6].cellType == InfoRowTableViewCell.self).to(beTrue())

        let nutritionVC = viewControllers[2] as! FormTableViewController
        form = nutritionVC.form
        rows = form.rows

        expect(form.title).to(equal(NSLocalizedString("product-detail.page-title.nutrition", comment: "Product detail, nutrition")))
        expect(rows[0].value as? String).to(equal(product.nutriscore))
        expect(rows[0].cellType == NutritionHeaderTableViewCell.self).to(beTrue())
        expect(rows[1].label).to(equal(InfoRowKey.servingSize.localizedString))
        expect(rows[1].value as? String).to(equal(product.servingSize))
        expect(rows[1].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[2].label).to(equal(InfoRowKey.carbonFootprint.localizedString))
        expect(rows[2].value as? String).to(equal("\(product.nutriments!.carbonFootprint!) \(product.nutriments!.carbonFootprintUnit!)"))
        expect(rows[2].cellType == InfoRowTableViewCell.self).to(beTrue())
        expect(rows[3].label).to(beNil())
        expect(rows[3].cellType == NutritionLevelsTableViewCell.self).to(beTrue())

        let nutritionTableVC = viewControllers[3] as! NutritionTableFormTableViewController
        form = nutritionTableVC.form
        rows = form.rows

        expect(form.title).to(equal(NSLocalizedString("product-detail.page-title.nutrition-table", comment: "Product detail, nutrition table")))
        expect(rows[0].label).to(beNil())
        expect(rows[0].cellType == HostedViewCell.self).to(beTrue())
        expect(rows[0].isCopiable).to(beFalse())
        expect(rows[1].label).to(beNil())
        expect(rows[1].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[2].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.energy?.localized.localizedString))
        expect((rows[2].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.energy!.per100g!.asTwoDecimalRoundedString) \(product.nutriments!.energy!.unit!)"))
        expect((rows[2].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.energy!.perServing!.asTwoDecimalRoundedString) \(product.nutriments!.energy!.unit!)"))
        expect((rows[2].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[2].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[3].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.fats[0].localized.localizedString))
        expect((rows[3].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.fats[0].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.fats[0].unit!)"))
        expect((rows[3].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.fats[0].perServing!.asTwoDecimalRoundedString) \(product.nutriments!.fats[0].unit!)"))
        expect((rows[3].value as? NutritionTableRow)?.highlight).to(beTrue())
        expect(rows[3].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[4].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.fats[1].localized.localizedString))
        expect((rows[4].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.fats[1].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.fats[1].unit!)"))
        expect((rows[4].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.fats[1].perServing!.asTwoDecimalRoundedString) \(product.nutriments!.fats[1].unit!)"))
        expect((rows[4].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[4].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[5].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.carbohydrates[0].localized.localizedString))
        expect((rows[5].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.carbohydrates[0].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.carbohydrates[0].unit!)"))
        expect((rows[5].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.carbohydrates[0].perServing!.asTwoDecimalRoundedString) \(product.nutriments!.carbohydrates[0].unit!)"))
        expect((rows[5].value as? NutritionTableRow)?.highlight).to(beTrue())
        expect(rows[5].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[6].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.carbohydrates[1].localized.localizedString))
        expect((rows[6].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.carbohydrates[1].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.carbohydrates[1].unit!)"))
        expect((rows[6].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.carbohydrates[1].perServing!.asTwoDecimalRoundedString) \(product.nutriments!.carbohydrates[1].unit!)"))
        expect((rows[6].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[6].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[7].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.fiber!.localized.localizedString))
        expect((rows[7].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.fiber!.per100g!.asTwoDecimalRoundedString) \(product.nutriments!.fiber!.unit!)"))
        expect((rows[7].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.fiber!.perServing!.asTwoDecimalRoundedString) \(product.nutriments!.fiber!.unit!)"))
        expect((rows[7].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[7].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[8].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.proteins[0].localized.localizedString))
        expect((rows[8].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.proteins[0].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.proteins[0].unit!)"))
        expect((rows[8].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.proteins[0].perServing!.asTwoDecimalRoundedString) \(product.nutriments!.proteins[0].unit!)"))
        expect((rows[8].value as? NutritionTableRow)?.highlight).to(beTrue())
        expect(rows[8].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[9].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.salt!.localized.localizedString))
        expect((rows[9].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.salt!.per100g!.asTwoDecimalRoundedString) \(product.nutriments!.salt!.unit!)"))
        expect((rows[9].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.salt!.perServing!.asTwoDecimalRoundedString) \(product.nutriments!.salt!.unit!)"))
        expect((rows[9].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[9].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[10].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.sodium?.localized.localizedString))
        expect((rows[10].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.sodium!.per100g!.asTwoDecimalRoundedString) \(product.nutriments!.sodium!.unit!)"))
        expect((rows[10].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.sodium!.perServing!.asTwoDecimalRoundedString) \(product.nutriments!.sodium!.unit!)"))
        expect((rows[10].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[10].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[11].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.alcohol?.localized.localizedString))
        expect((rows[11].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.alcohol!.per100g!.asTwoDecimalRoundedString) \(product.nutriments!.alcohol!.unit!)"))
        expect((rows[11].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.alcohol!.perServing!.asTwoDecimalRoundedString) \(product.nutriments!.alcohol!.unit!)"))
        expect((rows[11].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[11].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[12].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.vitamins[0].localized.localizedString))
        expect((rows[12].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.vitamins[0].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.vitamins[0].unit!)"))
        expect((rows[12].value as? NutritionTableRow)?.perServingValue).to(equal("\(product.nutriments!.vitamins[0].perServing!.asTwoDecimalRoundedString) \(product.nutriments!.vitamins[0].unit!)"))
        expect((rows[12].value as? NutritionTableRow)?.highlight).to(beTrue())
        expect(rows[12].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
        expect((rows[13].value as? NutritionTableRow)?.label).to(equal(product.nutriments!.minerals[0].localized.localizedString))
        expect((rows[13].value as? NutritionTableRow)?.perSizeValue).to(equal("\(product.nutriments!.minerals[0].per100g!.asTwoDecimalRoundedString) \(product.nutriments!.minerals[0].unit!)"))
        expect((rows[13].value as? NutritionTableRow)?.perServingValue).to(beNil())
        expect((rows[13].value as? NutritionTableRow)?.highlight).to(beFalse())
        expect(rows[13].cellType == NutritionTableRowTableViewCell.self).to(beTrue())
    }

    // MARK: - didTapScanButton
    func testDidTapScanButtonPushesScannerView() {
        viewController.didTapScanButton(UIBarButtonItem())

        expect(self.navigationController.pushedViewController is ScannerViewController).toEventually(beTrue())
        expect(self.navigationController.isViewControllerPushAnimated).toEventually(beTrue())
    }

    // MARK: - Helper functions
    private func buildProductForJsonFile(_ fileName: String) -> Product {
        let map = Map(mappingType: .fromJSON, JSON: TestHelper.sharedInstance.getJson(fileName))
        var product = Product(map: map)!
        product.mapping(map: map)
        return product
    }
}
