//
//  ProductDetailViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductDetailViewController: ButtonBarPagerTabStripViewController, DataManagerClient {

    var hideSummary: Bool = false
    var product: Product!
    var latestRobotoffQuestions: [RobotoffQuestion] = []
    var dataManager: DataManagerProtocol!
    private var notificationCentertoken: NotificationCenterToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBarView.register(UINib(nibName: "ButtonBarView", bundle: nil), forCellWithReuseIdentifier: "Cell")
        if #available(iOS 13.0, *) {
            buttonBarView.backgroundColor = .systemBackground
            settings.style.selectedBarBackgroundColor = .secondarySystemBackground
        } else {
            buttonBarView.backgroundColor = .white
            settings.style.selectedBarBackgroundColor = .white
        }
        buttonBarView.selectedBar.backgroundColor = self.view.tintColor
        addEditButton()
        if let tbc = tabBarController {
            if let items = tbc.tabBar.items {
                for (index, item) in items.enumerated() {
                    switch index {
                    case 0: item.accessibilityIdentifier = AccessibilityIdentifiers.Product.detailSummaryView
                    case 1: item.accessibilityIdentifier = AccessibilityIdentifiers.Product.detailIngredientsView
                    case 2: item.accessibilityIdentifier = AccessibilityIdentifiers.Product.detailNutritionView
                    default: break
                    }
                }
            }
        }
        setUserAgent()

        notificationCentertoken = NotificationCenter.default.observe(
            name: .productChangesUploaded,
            object: nil,
            queue: .main
        ) { [weak self] notif in
            guard let barcode = notif.userInfo?["barcode"] as? String else {
                return
            }
            if barcode == self?.product.barcode {
                self?.refreshProduct {}
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //TODO: Answers.logContentView(withName: "Product's detail", contentType: "product_detail", contentId: product.barcode, customAttributes: ["product_name": product.name ?? ""])

        if let parentVc = parent as? UINavigationController {

            parentVc.navigationBar.isTranslucent = false

            let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton(_:)))
            var buttons: [UIBarButtonItem] = navigationItem.rightBarButtonItems ?? []
            buttons.insert(shareButton, at: 0)
            navigationItem.rightBarButtonItems = buttons
        }

        self.refreshLatestRobotoffQuestion()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isTranslucent = true
        if var buttons = navigationItem.rightBarButtonItems, !buttons.isEmpty {
            buttons.remove(at: 0)
            navigationItem.rightBarButtonItems = buttons
        }
    }

    fileprivate func refreshLatestRobotoffQuestion() {
        self.latestRobotoffQuestions = []

        if let barcode = self.product.barcode {
            dataManager.getLatestRobotoffQuestions(forBarcode: barcode) { [weak self] (questions: [RobotoffQuestion]) in
                guard let zelf = self else {
                    return
                }
                zelf.latestRobotoffQuestions = questions
                zelf.updateForms(with: zelf.product)
            }
        }
    }

    private func setUserAgent() {
        var userAgentString = ""
        if let validAppName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String {
            userAgentString = validAppName
        }
        if let validVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            userAgentString += "; version " + validVersion
        }

        if let validBuild = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String {
            userAgentString += "; build " +  validBuild + " - product"
        }
        UserDefaults.standard.register(defaults: ["UserAgent": userAgentString])
    }

    // MARK: - Product pages

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()

        vcs.append(getSummaryVC())
        vcs.append(getIngredientsVC())
        if let nutritionVC = getNutritionVC() {
            vcs.append(nutritionVC)
        }
        if let environmentImpactVC = getEnvironmentImpactVC() {
            vcs.append(environmentImpactVC)
        }

        return vcs
    }

    fileprivate func getSummaryVC() -> UIViewController {
        let form = createSummaryForm()
        let summaryFormTableVC = SummaryFormTableViewController(with: form, dataManager: dataManager)
        summaryFormTableVC.delegate = self
        summaryFormTableVC.hideSummary = hideSummary
        return summaryFormTableVC
    }

    fileprivate func getIngredientsVC() -> UIViewController {
        let form = createIngredientsForm()
        let ingredientsFormTableVC = IngredientsFormTableViewController(with: form, dataManager: dataManager)
        ingredientsFormTableVC.delegate = self
        return ingredientsFormTableVC
    }

    fileprivate func getNutritionVC() -> UIViewController? {
        guard let form = createNutritionForm() else { return nil }
        let nutritionTableFormTableVC = NutritionTableFormTableViewController(with: form, dataManager: dataManager)
        nutritionTableFormTableVC.delegate = self
        return nutritionTableFormTableVC
    }

    fileprivate func getEnvironmentImpactVC() -> UIViewController? {
        //if product.environmentImpactLevelTags?.isEmpty == false, let infoCard = product.environmentInfoCard, infoCard.isEmpty == false {
            let environmentImpactFormTableVC = EnvironmentImpactTableFormTableViewController()
            environmentImpactFormTableVC.product = product
            return environmentImpactFormTableVC
        //}
        //return nil
    }

    // MARK: - Form creation methods

    private func updateForms(with updatedProduct: Product) {
        self.product = updatedProduct

        for (index, viewController) in viewControllers.enumerated() {
            if let vc0 = viewController as? FormTableViewController {
                switch index {
                case 0:
                    vc0.form = createSummaryForm()
                    vc0.view.accessibilityIdentifier = AccessibilityIdentifiers.Product.detailSummaryView
                case 1:
                    vc0.form = createIngredientsForm()
                    vc0.view.accessibilityIdentifier = AccessibilityIdentifiers.Product.detailIngredientsView
                case 2:
                    vc0.form = createNutritionForm()
                    vc0.view.accessibilityIdentifier = AccessibilityIdentifiers.Product.detailNutritionView
                default: break
                }
            } else if let vc1 = viewController as? EnvironmentImpactTableFormTableViewController {
                vc1.product = product
            }
        }
    }

    private func createSummaryForm() -> Form {
        var rows = [FormRow]()

        // Header
        rows.append(FormRow(value: product as Any, cellType: SummaryHeaderCell.self))

        if !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableRobotoffWhenNotLoggedIn), !latestRobotoffQuestions.isEmpty {
            createFormRow(with: &rows, item: latestRobotoffQuestions, cellType: RobotoffQuestionTableViewCell.self)
        }

        createIngredientsAnalysisRows(rows: &rows)
        createNutrientsRows(rows: &rows)
        createAdditivesRows(with: &rows, product: product)

        // Rows
        createFormRow(with: &rows, item: product.barcode, label: InfoRowKey.barcode.localizedString, isCopiable: true)
        createFormRow(with: &rows, item: product.genericName, label: InfoRowKey.genericName.localizedString, isCopiable: true)
        createFormRow(with: &rows, item: product.packaging, label: InfoRowKey.packaging.localizedString)
        createFormRow(with: &rows, item: product.manufacturingPlaces, label: InfoRowKey.manufacturingPlaces.localizedString)
        createFormRow(with: &rows, item: product.origins, label: InfoRowKey.origins.localizedString)

        createFormRow(with: &rows, item: product.categoriesTags?.map({ (categoryTag: String) -> NSAttributedString in
            if let category = dataManager.category(forTag: categoryTag) {
                if let name = Tag.choose(inTags: Array(category.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forCategory: category)])
                }
            }
            return NSAttributedString(string: categoryTag)
        }), label: InfoRowKey.categories.localizedString)

        createFormRow(with: &rows, item: product.labelsTags?.map({ (labelTag: String) -> NSAttributedString in
            if let label = dataManager.label(forTag: labelTag) {
                if let name = Tag.choose(inTags: Array(label.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link : OFFUrlsHelper.url(forLabel: label)])
                }
            }
            return NSAttributedString(string: labelTag)
        }), label: InfoRowKey.labels.localizedString)

        createFormRow(with: &rows, item: product.embCodesTags?.map({ (tag: String) -> NSAttributedString in
            return NSAttributedString(string: tag.uppercased().replacingOccurrences(of: "-", with: " "),
                                      attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forEmbCodeTag: tag)])
        }), label: InfoRowKey.embCodes.localizedString)

        createFormRow(with: &rows, item: product.stores, label: InfoRowKey.stores.localizedString)
        createFormRow(with: &rows, item: product.countriesTags?.map({ (tag: String) -> NSAttributedString in
            if let country = dataManager.country(forTag: tag) {
                if let name = Tag.choose(inTags: Array(country.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(for: country)])
                }
            }
            return NSAttributedString(string: tag)
        }), label: InfoRowKey.countries.localizedString)

        // Footer
        rows.append(FormRow(value: product as Any, cellType: SummaryFooterCell.self))

        let summaryTitle = "product-detail.page-title.summary".localized

        return Form(title: summaryTitle, rows: rows)
    }

    // swiftlint:disable function_body_length
    private func createIngredientsForm() -> Form {
        var rows = [FormRow]()

        // Header
        rows.append(FormRow(value: product as Any, cellType: HostedViewCell.self))

        // Rows
        if let ingredientsList = product.ingredientsList {
            createFormRow(with: &rows, item: "\n" + ingredientsList, label: InfoRowKey.ingredientsList.localizedString)
        }
        createFormRow(with: &rows, item: product.allergens?.map({ (allergen: Tag) -> NSAttributedString in
            if let allergen = dataManager.allergen(forTag: allergen) {
                if let name = Tag.choose(inTags: Array(allergen.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forAllergen: allergen)])
                }
            }
            return NSAttributedString(string: allergen.value.capitalized)
        }), label: InfoRowKey.allergens.localizedString)

        if dataManager.listAllergies().isEmpty == false {
            if product.states?.contains("en:ingredients-to-be-completed") == true {
                if product.allergens == nil || product.allergens?.isEmpty == true {
                    createFormRow(with: &rows, item: "⚠️ " + "product-detail.ingredients.allergens-list.missing-infos".localized, label: InfoRowKey.allergens.localizedString)
                }
            }
        }
        createFormRow(with: &rows, item: product.traces?.map({ (trace: Tag) -> NSAttributedString in
            if let trace = dataManager.allergen(forTag: trace) {
                if let name = Tag.choose(inTags: Array(trace.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forAllergen: trace)])
                }
            }
            return NSAttributedString(string: trace.value.capitalized)
        }), label: InfoRowKey.traces.localizedString)

        createFormRow(with: &rows, item: product.vitamins?.map({ (vitamin: Tag) -> NSAttributedString in
            if let vitamin = dataManager.vitamin(forTag: vitamin) {
                if let name = Tag.choose(inTags: Array(vitamin.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forVitamin: vitamin)])
                }
            }
            return NSAttributedString(string: vitamin.value.capitalized)
        }), label: InfoRowKey.vitamins.localizedString)

        createFormRow(with: &rows, item: product.minerals?.map({ (mineral: Tag) -> NSAttributedString in
            if let mineral = dataManager.mineral(forTag: mineral) {
                if let name = Tag.choose(inTags: Array(mineral.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forMineral: mineral)])
                }
            }
            return NSAttributedString(string: mineral.value.capitalized)
        }), label: InfoRowKey.minerals.localizedString)

        createFormRow(with: &rows, item: product.nucleotides?.map({ (nucleotide: Tag) -> NSAttributedString in
            if let nucleotide = dataManager.nucleotide(forTag: nucleotide) {
                if let name = Tag.choose(inTags: Array(nucleotide.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forNucleotide: nucleotide)])
                }
            }
            return NSAttributedString(string: nucleotide.value.capitalized)
        }), label: InfoRowKey.nucleotidesList.localizedString)

        createFormRow(with: &rows, item: product.otherNutrients?.map({ (other: Tag) -> NSAttributedString in
            if let other = dataManager.allergen(forTag: other) {
                if let name = Tag.choose(inTags: Array(other.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: URL(string: "https:world-en.openfoodfacts.org")!])
                }
            }
            return NSAttributedString(string: other.value.capitalized)
        }), label: InfoRowKey.otherNutritionalSubstances.localizedString)

        //createFormRow(with: &rows, item: product.traces, label: InfoRowKey.traces.localizedString)

        createAdditivesRows(with: &rows, product: product)

        createFormRow(with: &rows, item: product.possiblePalmOilIngredients, label: InfoRowKey.possiblePalmOilIngredients.localizedString)

        let summaryTitle = "product-detail.page-title.ingredients".localized

        return Form(title: summaryTitle, rows: rows)
    }
    // swiftlint:enable function_body_length

    fileprivate func createAdditivesRows(with rows: inout [FormRow], product: Product) {
        guard let additives = product.additives, additives.isEmpty == false else {
            return
        }

        var items: [Any] = []
        items.append(NSAttributedString(string: " "))    //to have the first carriage return from the join with separator
        items.append(contentsOf: additives.map({ (additive: Tag) -> NSAttributedString in
            if let additive = dataManager.additive(forTag: additive) {
                if let name = Tag.choose(inTags: Array(additive.names)) {
                    return NSAttributedString(string: name.value, attributes: [NSAttributedString.Key.link: OFFUrlsHelper.url(forAdditive: additive)])
                }
            }

            return NSAttributedString(string: additive.value.uppercased())
        }))

        createFormRow(with: &rows, item: items, label: InfoRowKey.additives.localizedString, separator: "\n ")
    }

    private func createNutritionForm() -> Form? {
        var rows = [FormRow]()

        // Nutriscore cell
        if product.nutriscore != nil {
            // created to pass on the delegate with the nutriscore
            let headerRow = NutritionScoreTableRow(
                delegate as? NutritionHeaderTableViewCellDelegate,
                nutriscore: product.nutriscore,
                noFiberWarning: product.nutriscoreWarningNoFiber,
                noFruitsVegetablesNutsWarning: product.nutriscoreWarningNoFruitsVegetablesNuts)
            createFormRow(with: &rows, item: headerRow, cellType: NutritionHeaderTableViewCell.self)
        }

        // Info rows
        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
            createFormRow(with: &rows, item: "\(carbonFootprint) \(unit)", label: InfoRowKey.carbonFootprint.localizedString)
        }

        createNutrientsRows(rows: &rows)

        if let validStates = product.states,
            validStates.contains("en:nutrition-facts-completed") {
            createNutritionTableWebViewRow(rows: &rows)
            //createNutritionTableRows(rows: &rows)
        } else {
            createFormRow(with: &rows, item: product, cellType: HostedViewCell.self)
            createFormRow(with: &rows, item: "product-detail.nutrition-table.missing".localized, label: InfoRowKey.nutritionalTableHeader.localizedString, isCopiable: true)
        }

        if rows.isEmpty {
            return nil
        }

        return Form(title: "product-detail.page-title.nutrition".localized, rows: rows)
    }

    fileprivate func createIngredientsAnalysisRows(rows: inout [FormRow]) {
        let analysisDetails = self.dataManager.ingredientsAnalysis(forProduct: product)
        if !analysisDetails.isEmpty {
            product.ingredientsAnalysisDetails = analysisDetails
            createFormRow(with: &rows, item: product, cellType: IngredientsAnalysisTableViewCell.self)
        }
    }

    fileprivate func createNutrientsRows(rows: inout [FormRow]) {
        // Nutrition levels
        if product.nutritionLevels != nil {
            createFormRow(with: &rows, item: product, cellType: NutritionLevelsTableViewCell.self)
        }
    }

    fileprivate func createNutritionTableWebViewRow(rows: inout [FormRow]) {
        guard let html = product.nutritionTableHtml else {
            return
        }
        createFormRow(with: &rows, item: product, cellType: HostedViewCell.self)
        createFormRow(with: &rows, item: html, label: nil, cellType: ProductDetailWebViewTableViewCell.self, isCopiable: false)
    }

    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func createNutritionTableRows(rows: inout [FormRow]) {
        // Header
        createFormRow(with: &rows, item: product, cellType: HostedViewCell.self)

        if product.nutriments != nil || product.servingSize != nil {
            // Nutrition table rows
            let headerRow = NutritionTableRow(label: "",
                                              perSizeValue: "product-detail.nutrition-table.100g".localized,
                                              perServingValue: "product-detail.nutrition-table.serving".localized)
            createFormRow(with: &rows, item: headerRow, cellType: NutritionTableRowTableViewCell.self)
        }

        if let energy = product.nutriments?.energyKJ, let nutritionTableRow = energy.nutritionTableRow {
            createFormRow(with: &rows, item: nutritionTableRow, cellType: NutritionTableRowTableViewCell.self)
        }
        if let energy = product.nutriments?.energyKcal, let nutritionTableRow = energy.nutritionTableRow {
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
    }

    private func createFormRow(with array: inout [FormRow], item: Any?, label: String? = nil, cellType: ProductDetailBaseCell.Type = InfoRowTableViewCell.self, isCopiable: Bool = false, separator: String = ", ") {
        // Check item has a value, if so add to the array of rows.
        switch item {
        case let value as String:
            // Check if it's empty here insted of doing 'case let value as String where !value.isEmpty' because an empty String ("") would not match this case but the default one
            if !value.isEmpty {
                array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable, separator: separator))
            }
        case let value as [Any]:
            if !value.isEmpty {
                array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable, separator: separator))
            }
        default:
            if let value = item {
                array.append(FormRow(label: label, value: value, cellType: cellType, isCopiable: isCopiable, separator: separator))
            }
        }
    }

    // MARK: - Nav bar button

    @objc func didTapShareButton(_ sender: UIBarButtonItem) {
        SharingManager.shared.shareLink(name: product.name, string: URLs.urlForProduct(with: product.barcode), sender: sender, presenter: self)
    }

    // MARK: - edit button functions

    func addEditButton() {
         let editButton: UIBarButtonItem = .init(barButtonSystemItem: .edit, target: self, action: #selector(edit))
         navigationItem.rightBarButtonItem = editButton
     }

    @objc func edit() {
         if CredentialsController.shared.getUsername() == nil {
             guard let loginVC = UserViewController.loadFromStoryboard(named: .settings) as? UserViewController else {
                 return }
             loginVC.dataManager = dataManager
             //loginVC.delegate = self

             let navVC = UINavigationController(rootViewController: loginVC)
             loginVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ProductDetailViewController.dismissVC))
             loginVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ProductDetailViewController.dismissVC))

             self.present(navVC, animated: true)

             return
         }

         if let product = self.product {
             let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: nil)
             if let addProductVC = storyboard.instantiateInitialViewController() as? ProductAddViewController {
                 addProductVC.productToEdit = product
                 addProductVC.dataManager = dataManager

                 let navVC = UINavigationController(rootViewController: addProductVC)
                 if self.responds(to: #selector(ProductDetailViewController.dismissVC)) {
                     addProductVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ProductDetailViewController.dismissVC))
                 }
                 if addProductVC.responds(to: #selector(ProductAddViewController.saveAll)) {
                     addProductVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: addProductVC, action: #selector(ProductAddViewController.saveAll))
                 }
                 navVC.modalPresentationStyle = .fullScreen

                 self.present(navVC, animated: true)
             }
         }
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - Refresh delegate

protocol ProductDetailRefreshDelegate: class {
    func refreshProduct(completion: () -> Void)
}

extension ProductDetailViewController: ProductDetailRefreshDelegate {
    func refreshProduct(completion: () -> Void) {
        if let barcode = self.product.barcode {
            dataManager.getProduct(byBarcode: barcode, isScanning: false, isSummary: false, onSuccess: { [weak self] response in
                if let updatedProduct = response {
                    self?.updateForms(with: updatedProduct)
                    self?.refreshLatestRobotoffQuestion()
                }
            }, onError: { [weak self] error in
                // No error should be thrown here, as the product was loaded previously
                AnalyticsManager.record(error: error)
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }

        completion()
    }
}

extension ProductDetailViewController: NutritionHeaderTableViewCellDelegate {

    // function to let the delegate know that the switch changed
    //func tagListViewAddImageTableViewCell(_ sender: TagListViewAddImageTableViewCell, receivedDoubleTapOn tagListView:TagListView)
    public func nutritionHeaderTableViewCellDelegate(_ sender: NutritionHeaderTableViewCell, receivedTapOn button: UIButton) {

        if let url = URL(string: URLs.NutriScore) {
            openUrlInApp(url)
        } else if let url = URL(string: URLs.SupportOpenFoodFacts) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }

}
