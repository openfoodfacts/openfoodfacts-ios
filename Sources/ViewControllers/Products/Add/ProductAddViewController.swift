//
//  ProductAddViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import NotificationBanner

// swiftlint:disable:next type_body_length
class ProductAddViewController: TakePictureViewController {
    // IBOutlets

    @IBOutlet weak var barcodeTitleLabel: UILabel! {
        didSet {
            barcodeTitleLabel?.text = "product-add.titles.barcode".localized
        }
    }
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var topExplainationText: UILabel! {
        didSet {
            topExplainationText?.text = "product-add.titles.top-explainations".localized
        }
    }
    @IBOutlet weak var picturesContainerView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var productSectionTitle: UILabel! {
        didSet {
            productSectionTitle?.text = "product-add.titles.product-info".localized
        }
    }
    @IBOutlet weak var productNameTitleLabel: UILabel! {
        didSet {
            productNameTitleLabel?.text = "product-add.label.product-name".localized
        }
    }
    @IBOutlet weak var productNameField: UITextField!
    @IBOutlet weak var productCategoryTitleLabel: UILabel! {
        didSet {
            productCategoryTitleLabel?.text = "product-add.label.category".localized
        }
    }
    @IBOutlet weak var productCategoryField: UITextField! {
        didSet {
            productCategoryField?.placeholder = "product-add.label.category".localized
        }
    }
    @IBOutlet weak var productCategoryNutriScoreExplanationLabel: UILabel!
    @IBOutlet weak var brandsTitleLabel: UILabel! {
        didSet {
            brandsTitleLabel?.text = "product-add.placeholder.brand".localized
        }
    }
    @IBOutlet weak var brandsField: UITextField!
    @IBOutlet weak var quantityTitleLabel: UILabel! {
        didSet {
            quantityTitleLabel?.text = "product-add.label.quantity".localized
        }
    }
    @IBOutlet weak var quantityExampleLabel: UILabel! {
        didSet {
            quantityExampleLabel?.text = "product-add.label.quantity-example".localized
        }
    }
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var packagingTitleLabel: UILabel!
    @IBOutlet weak var packagingField: UITextField!
    @IBOutlet weak var languageTitleLabel: UILabel!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet weak var productTextSection: UIView!
    @IBOutlet weak var saveProductInfosButton: UIButton!
    @IBOutlet var productInformationsTextFields: [UITextField]!
    @IBOutlet weak var lastSavedProductInfosLabel: UILabel!

    @IBOutlet weak var noNutritionDataSwitch: UISwitch!
    @IBOutlet weak var nutritiveNutriScoreEXplanationLabel: UILabel!
    @IBOutlet weak var nutritiveSectionTitle: UILabel! {
        didSet {
            nutritiveSectionTitle?.text = "product-add.titles.nutritive".localized
        }
    }
    @IBOutlet weak var nutriscoreStackView: UIStackView! {
        didSet {
            nutriscoreStackView?.isHidden = true
        }
    }
    @IBOutlet weak var nutriScoreView: NutriScoreView!
    @IBOutlet weak var portionSizeInputView: EditNutritiveValueView!
    @IBOutlet weak var nutritivePortionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nutritiveValuesStackView: UIStackView!
    @IBOutlet weak var addNutrimentButton: UIButton!
    @IBOutlet weak var saveNutrimentsButton: UIButton!
    @IBOutlet weak var lastSavedNutrimentsLabel: UILabel!

    @IBOutlet weak var ingredientsSectionTitle: UILabel!
    @IBOutlet weak var novaGroupStackView: UIStackView! {
        didSet {
            novaGroupStackView?.isHidden = true
        }
    }
    @IBOutlet weak var novaGroupView: NovaGroupView!
    @IBOutlet weak var ingredientsOCRExplanationLabel: UILabel! {
        didSet {
            ingredientsOCRExplanationLabel?.text = "product-add.ingredients.explaination".localized
        }
    }
    @IBOutlet weak var ingredientsNovaExplanationLabel: UILabel!
    @IBOutlet weak var ingredientsTextField: UITextView! {
        didSet {
            ingredientsTextField?.text = ""
        }
    }
    @IBOutlet weak var ignoreIngredientsButton: UIButton! {
        didSet {
            ignoreIngredientsButton?.setTitle("product-add.ingredients.button-delete".localized, for: .normal)
            ignoreIngredientsButton?.titleLabel?.lineBreakMode = .byWordWrapping
            ignoreIngredientsButton?.titleLabel?.numberOfLines = 2
        }
    }
    @IBOutlet weak var saveIngredientsButton: UIButton! {
        didSet {
            saveIngredientsButton?.setTitle("product-add.ingredients.button-save".localized, for: .normal)
            saveIngredientsButton?.titleLabel?.lineBreakMode = .byWordWrapping
            saveIngredientsButton?.titleLabel?.numberOfLines = 2
        }
    }
    @IBOutlet weak var lastSavedIngredientsLabel: UILabel! {
        didSet {
            lastSavedIngredientsLabel?.isHidden = true
        }
    }
    @IBOutlet weak var lastSavedIngredientsOCRLabel: UILabel!

    @IBOutlet var saveButtons: [UIButton]!

    // Constants

    // ivars

    lazy var product = Product()
    lazy var productPostErrorAlert: UIAlertController = {
        let alert = UIAlertController(title: "product-add.save-error.title".localized,
                                      message: "product-add.save-error.message".localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.action.ok".localized,
                                      style: .default,
                                      handler: { _ in alert.dismiss(animated: true, completion: nil) }))
        return alert
    }()

    // Mandatory ivars

    override var barcode: String! {
        didSet {
            product.barcode = barcode
            if productToEdit == nil {
                productToEdit = Product.init()
                productToEdit?.barcode = barcode
            }
        }
    }

    var productToEdit: Product? {
        didSet {
            // has a barcode been passed on from the scanner?
            if let barcode = productToEdit?.barcode {
                self.barcode = barcode
            }
        }
    }

    private var productHasBeenEdited = false {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = productHasBeenEdited
        }
    }

    // Private vars

    fileprivate var activeField: UIView?
    fileprivate var lastOffset: CGPoint = CGPoint(x: 0, y: 0)

    private var languagePickerController: PickerViewController?
    private var languagePickerToolbarController: PickerToolbarViewController?

    private var productCategory: Category?
    private var productCategoryCustomName: String?

    fileprivate var saltUnitChangeObserver: NSKeyValueObservation?
    fileprivate var sodiumUnitChangeObserver: NSKeyValueObservation?

    // These keys
    static let displayedNutrimentItemsByDefault = [
        OFFJson.EnergyKey,
        OFFJson.EnergyKcalKey,
        OFFJson.FatKey,
        OFFJson.SaturatedFatKey,
        OFFJson.CarbohydratesKey,
        OFFJson.SugarsKey,
        OFFJson.FiberKey,
        OFFJson.ProteinsKey,
        OFFJson.SaltKey,
        OFFJson.SodiumKey,
        OFFJson.AlcoholKey
    ]
    fileprivate var displayedNutrimentItems = displayedNutrimentItemsByDefault

    override func viewDidLoad() {
        self.title = "product-add.title".localized
        productHasBeenEdited = false
        languageTitleLabel.text = "product-add.label.language".localized
        saveButtons.forEach { (button: UIButton) in
            button.setTitle("generic.save".localized, for: .normal)
        }
        lastSavedProductInfosLabel.isHidden = true

        nutritivePortionSegmentedControl.setTitle("product-add.nutritive.choice.per-hundred-grams".localized, forSegmentAt: 0)
        nutritivePortionSegmentedControl.setTitle("product-add.nutritive.choice.per-portion".localized, forSegmentAt: 1)
        portionSizeInputView.titleLabel.text = "product-detail.nutrition.serving-size".localized
        portionSizeInputView.inputTextField.placeholder = "product-detail.nutrition.serving-size".localized
        addNutrimentButton.setTitle("product-add.nutritive.add-nutriment".localized + " >", for: .normal)
        lastSavedNutrimentsLabel.isHidden = true

        refreshNutritiveInputsViews()

        ingredientsSectionTitle.text = "product-add.titles.ingredients".localized

        showNotSavedIndication(label: lastSavedIngredientsOCRLabel, key: "ocr-ingredients")

        configureLanguageField()
        configureDelegates()
        configureNotifications()
        // Issue #325
        // The app seems to try first a locally stored product and then a realm stored product
        // Both were nil however, and nothing happens
        // As there is a new barcode, there should be a local product,
        // but it is nowhere created
        // solutio is to create productToEdit, when the barcode is set
        // and assign the barcode to productToEdit

        if let productToEdit = self.productToEdit {
            self.title = "product-add.title-edit".localized
            self.product = productToEdit
            fillForm(withProduct: productToEdit)
        }
        if let barcode = self.barcode {
            let pendingUploadItem = dataManager.getItemPendingUpload(forBarcode: barcode)
            if pendingUploadItem != nil {
                fillForm(withPendingUploadItem: pendingUploadItem!)
            }
        }
        setUserAgent()
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
            userAgentString += "; build " +  validBuild + " - add"
        }
        UserDefaults.standard.register(defaults: ["UserAgent": userAgentString])    }

    // swiftlint:enable function_body_length

    fileprivate func fillProductFromInfosForm() {
        if let lang = product.lang {
            product.names[lang] = productNameField.text
        } else {
            product.name = productNameField.text
        }

        if let brand = brandsField.text {
            product.brands = [brand]
        }

        if let category = productCategory {
            product.categories = [category.code]
        } else if let category = productCategoryCustomName {
            product.categories = [(Bundle.main.preferredLocalizations.first ?? "en") + ":" + category]
        } else {
            product.categories = nil
        }

        product.quantity = quantityField.text
        if let validPackingText = packagingField.text {
            let array = validPackingText.split(separator: ",")
            product.packaging = array.compactMap {String($0)}
        }
    }

    fileprivate func fillProductFromNutriments() -> [RealmPendingUploadNutrimentItem] {
        if let servingSize = portionSizeInputView.inputTextField.text {
            product.servingSize = servingSize
        }

        var nutriments = [RealmPendingUploadNutrimentItem]()

        product.noNutritionData = noNutritionDataSwitch.isOn ? "on" : "off"

        if !noNutritionDataSwitch.isOn {
            if nutritivePortionSegmentedControl.selectedSegmentIndex == 0 {
                product.nutritionDataPer = .hundredGrams
            } else {
                product.nutritionDataPer = .serving
            }

            nutritiveValuesStackView.arrangedSubviews.forEach { (view: UIView) in
                if let view = view as? EditNutritiveValueView {
                    if let inputValue = view.getInputValue() {
                        let pendingItem = RealmPendingUploadNutrimentItem()
                        pendingItem.code = view.nutrimentCode
                        pendingItem.modifier = inputValue.modifier
                        pendingItem.value = inputValue.value
                        pendingItem.unit = view.selectedUnit ?? ""
                        nutriments.append(pendingItem)
                    }
                }
            }
        }

        return nutriments
    }

    @objc func saveAll() {
        self.view.endEditing(true)
        saveProductInfosButton.isEnabled = false

        self.showSavingIndication(label: lastSavedProductInfosLabel, key: "save-info")

        fillProductFromInfosForm()

        dataManager.addProduct(product, onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.showSavedSuccess(label: self?.lastSavedProductInfosLabel, key: "save-info")
                self?.saveProductInfosButton.isEnabled = true
                self?.refreshNovaScore()
            }
            }, onError: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.showSavedError(label: self?.lastSavedProductInfosLabel, key: "save-info")
                    self?.saveProductInfosButton.isEnabled = true
                }
        })
        saveNutriments()

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapSaveProductButton(_ sender: UIButton) {
        saveAll()
    }

    @IBAction func didTapSaveNutrimentsButton(_ sender: Any) {
        self.view.endEditing(true)
        self.saveNutrimentsButton.isEnabled = false

        self.showSavingIndication(label: lastSavedProductInfosLabel, key: "save-info")
        saveNutriments()
    }

    func saveNutriments() {
        self.showSavingIndication(label: lastSavedNutrimentsLabel, key: "save-nutriments")

        fillProductFromInfosForm()
        let nutriments = fillProductFromNutriments()

        dataManager.addProductNutritionTable(product, nutritionTable: nutriments, onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.showSavedSuccess(label: self?.lastSavedProductInfosLabel, key: "save-info")
                self?.showSavedSuccess(label: self?.lastSavedNutrimentsLabel, key: "save-nutriments")
                self?.saveNutrimentsButton.isEnabled = true

                self?.refreshNovaScore()
            }
            }, onError: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.showSavedError(label: self?.lastSavedProductInfosLabel, key: "save-info")
                    self?.showSavedError(label: self?.lastSavedNutrimentsLabel, key: "save-nutriments")
                    self?.saveNutrimentsButton.isEnabled = true
                }
        })
    }

    @IBAction func didTapIgnoreIngredientsButton(_ sender: Any) {
        self.ingredientsTextField.text = nil
        self.lastSavedIngredientsLabel.isHidden = true
    }

    @IBAction func didTapSaveIngredientsButton(_ sender: Any) {
        self.view.endEditing(true)
        self.ignoreIngredientsButton.isEnabled = false
        self.saveIngredientsButton.isEnabled = false

        self.showSavingIndication(label: lastSavedProductInfosLabel, key: "save-info")
        self.showSavingIndication(label: lastSavedNutrimentsLabel, key: "save-nutriments")
        self.showSavingIndication(label: lastSavedIngredientsLabel, key: "save-ingredients")

        fillProductFromInfosForm()
        let nutriments = fillProductFromNutriments()

        if let lang = product.lang {
            self.product.ingredients[lang] = self.ingredientsTextField.text
        } else {
            self.product.ingredientsList = self.ingredientsTextField.text
        }

        dataManager.addProductNutritionTable(product, nutritionTable: nutriments, onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.showSavedSuccess(label: self?.lastSavedProductInfosLabel, key: "save-info")
                self?.showSavedSuccess(label: self?.lastSavedNutrimentsLabel, key: "save-nutriments")
                self?.showSavedSuccess(label: self?.lastSavedIngredientsLabel, key: "save-ingredients")
                self?.ignoreIngredientsButton.isEnabled = true
                self?.saveIngredientsButton.isEnabled = true
                self?.refreshNovaScore()
            }
            }, onError: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.showSavedError(label: self?.lastSavedProductInfosLabel, key: "save-info")
                    self?.showSavedError(label: self?.lastSavedNutrimentsLabel, key: "save-nutriments")
                    self?.showSavedError(label: self?.lastSavedIngredientsLabel, key: "save-ingredients")
                    self?.ignoreIngredientsButton.isEnabled = true
                    self?.saveIngredientsButton.isEnabled = true
                }
        })
    }

    fileprivate func refreshNovaScore() {
        guard let barcode = product.barcode else { return }
        dataManager.getProduct(byBarcode: barcode, isScanning: false, isSummary: true, onSuccess: { [weak self] (distantProduct: Product?) in
            DispatchQueue.main.async {
                if let distantProduct = distantProduct {
                    if let nutriscoreString = distantProduct.nutriscore,
                        let score = NutriScoreView.Score(rawValue: nutriscoreString) {
                        self?.nutriScoreView.currentScore = score
                        self?.nutriscoreStackView.isHidden = false
                        self?.productCategoryNutriScoreExplanationLabel.text = ""
                        self?.productCategoryNutriScoreExplanationLabel.isHidden = true
                        self?.nutritiveNutriScoreEXplanationLabel.isHidden = true
                    } else {
                        self?.nutriscoreStackView.isHidden = true
                        self?.productCategoryNutriScoreExplanationLabel.text = "product-add.details.category".localized
                        self?.productCategoryNutriScoreExplanationLabel.isHidden = false
                        self?.nutritiveNutriScoreEXplanationLabel.isHidden = false

                    }

                    if let novaGroupString = distantProduct.novaGroup,
                        let novaGroup = NovaGroupView.NovaGroup(rawValue: "\(novaGroupString)") {
                        self?.novaGroupView.novaGroup = novaGroup
                        self?.novaGroupStackView.isHidden = false
                        self?.ingredientsNovaExplanationLabel.isHidden = true
                    } else {
                        self?.novaGroupStackView.isHidden = true
                        self?.ingredientsNovaExplanationLabel.isHidden = false
                    }
                }
            }
            }, onError: {_ in })
    }

    @IBAction func addNutrimentButtonTapped(_ sender: Any) {
        //open select nutriment
        let selectNutrimentViewController = SelectNutrimentViewController(nibName: "SelectNutrimentViewController", bundle: nil)
        selectNutrimentViewController.dataManager = self.dataManager
        selectNutrimentViewController.delegate = self
        self.navigationController?.pushViewController(selectNutrimentViewController, animated: true)
    }

    @IBAction func noNutritionDataSwitchToggled(_ sender: Any) {
        updateNoNutritionDataSwitchVisibility(animated: true)
    }

    fileprivate func updateNoNutritionDataSwitchVisibility(animated: Bool) {
        let isHidden = noNutritionDataSwitch.isOn
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.nutritivePortionSegmentedControl.isHidden = isHidden
                self.nutritiveValuesStackView.isHidden = isHidden
                self.addNutrimentButton.isHidden = isHidden
            }
        } else {
            self.nutritivePortionSegmentedControl.isHidden = isHidden
            self.nutritiveValuesStackView.isHidden = isHidden
            self.addNutrimentButton.isHidden = isHidden
        }
        showNotSavedIndication(label: lastSavedNutrimentsLabel, key: "save-nutriments")

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TakePictureSegue" {
            guard let destination = segue.destination as? PictureTableViewController else { return; }
            destination.delegate = self
            destination.barcode = barcode
            destination.dataManager = dataManager
            destination.productToEdit = productToEdit
        }
    }

    fileprivate func refreshNutritiveInputsViews() {
        while nutritiveValuesStackView.arrangedSubviews.count < displayedNutrimentItems.count {
            let newView = EditNutritiveValueView(frame: CGRect(x: 0, y: 0, width: nutritiveValuesStackView.frame.width, height: 44))
            newView.inputTextField.delegate = self
            newView.inputTextField.keyboardType = .numbersAndPunctuation
            nutritiveValuesStackView.addArrangedSubview(newView)
        }
        while nutritiveValuesStackView.arrangedSubviews.count > displayedNutrimentItems.count, let last = nutritiveValuesStackView.arrangedSubviews.last {
            nutritiveValuesStackView.removeArrangedSubview(last)
            last.removeFromSuperview()
        }

        displayedNutrimentItems.enumerated().forEach { (index: Int, element: String) in
            if let view = nutritiveValuesStackView.arrangedSubviews[index] as? EditNutritiveValueView {
                let nutriment = dataManager.nutriment(forTag: element)
                // The element seems to be the json-key (we should use the actual enum).
                // Note that the translations come from the Nutriments taxonomy
                var nutrimentName = nutriment?.names.chooseForCurrentLanguage()?.value ?? element

                // This is a stopgap, pending this translation in the Nutriments taxonomy
                if nutrimentName == "energy-kcal" {
                    nutrimentName = "nutrition.energy.kcal".localized
                }

                view.nutrimentCode = element
                view.titleLabel.text = nutrimentName
                view.inputTextField.placeholder = nutrimentName

                view.tooMuchLabel.isHidden = true
                view.delegate = self

                switch element {
                case OFFJson.EnergyKey: view.displayedUnit = .kJoule
                case OFFJson.EnergyKcalKey: view.displayedUnit = .kcal
                case OFFJson.AlcoholKey: view.displayedUnit = .alcohol
                case OFFJson.PhKey: view.displayedUnit = .none
                case let element where ProductAddViewController.displayedNutrimentItemsByDefault.contains(element):
                    view.displayedUnit = .units
                default: view.displayedUnit = .allUnits
                }
            }
        }
    }

    private func configureLanguageField() {
        let languages = dataManager.getLanguages()

        let languageValue = product.lang ?? Locale.current.languageCode ?? "en"
        self.product.lang = languageValue

        let defaultValue: Int? = languages.firstIndex(where: { $0.code == languageValue })

        self.languagePickerController = PickerViewController(data: languages, defaultValue: defaultValue, delegate: self)
        self.languagePickerToolbarController = PickerToolbarViewController(title: "product-add.language.toolbar-title".localized, delegate: self)

        if let pickerView = languagePickerController?.view as? UIPickerView {
            self.languageField.inputView = pickerView
        }

        if let toolbarView = languagePickerToolbarController?.view as? UIToolbar {
            self.languageField.inputAccessoryView = toolbarView
        }

        self.languageField.text = Locale.current.localizedString(forIdentifier: languageValue)

        // Hide blinking cursor
        self.languageField.tintColor = .clear
    }

    private func configureDelegates() {
        productNameField?.delegate = self
        brandsField?.delegate = self
        productCategoryField?.delegate = self
        quantityField?.delegate = self
        packagingField?.delegate = self
        languageField?.delegate = self

        portionSizeInputView?.displayedUnit = .none
        portionSizeInputView?.inputTextField.delegate = self
        ingredientsTextField?.delegate = self
    }

    private func configureNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    fileprivate func showNotSavedIndication(label: UILabel?, key: String) {
        label?.text = "⚠️ " + "product-add.\(key).not-yet".localized
        label?.isHidden = false
        productHasBeenEdited = true
    }

    fileprivate func showSavingIndication(label: UILabel?, key: String) {
        label?.text = "📡 " + "product-add.\(key).saving".localized
        label?.isHidden = false
    }

    fileprivate func showSavedSuccess(label: UILabel?, key: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        productHasBeenEdited = false
        label?.text = "💾 " + "product-add.\(key).success".localized + " " + dateFormatter.string(from: Date())
        label?.isHidden = false
    }

    fileprivate func showSavedError(label: UILabel?, key: String) {
        label?.text =  "🚨 " + "product-add.\(key).error".localized
        label?.isHidden = false
    }

    private func refreshProductTranslatedValuesFromLang() {
        //if let lang = product.lang {
            //productNameField.text = product.names[lang]
            //ingredientsTextField.text = product.ingredients[lang]
        //} else {
            productNameField.text = product.name
            ingredientsTextField.text = product.ingredientsList
        //}

    }

    private func fillForm(withProduct product: Product) {
        topExplainationText.isHidden = true

        self.refreshProductTranslatedValuesFromLang()

        barcodeLabel.text = product.barcode

        brandsField.text = product.brands?.joined(separator: ", ")

        if let categorieTag = product.categoriesTags?.first {
            if let categorie = dataManager.category(forTag: categorieTag) {
                productCategoryField.text = categorie.names.chooseForCurrentLanguage()?.value ?? categorieTag
            } else {
                productCategoryField.text = categorieTag
            }
        }

        quantityField?.text = product.quantity
        packagingField?.text = product.packaging?.compactMap {$0}.joined(separator: ", ")
        ingredientsTextField.text = product.ingredientsList
        ingredientsOCRExplanationLabel.isHidden = product.ingredientsList != nil && !product.ingredientsList!.isEmpty
        noNutritionDataSwitch.isOn = product.noNutritionData == "on"
        updateNoNutritionDataSwitchVisibility(animated: false)

        portionSizeInputView.inputTextField.text = product.servingSize

        if let nutritionDataPer = product.nutritionDataPer {
            switch nutritionDataPer {
            case .hundredGrams: nutritivePortionSegmentedControl.selectedSegmentIndex = 0
            case .serving: nutritivePortionSegmentedControl.selectedSegmentIndex = 1
            }
        }

        if let allNutriments = product.nutriments?.allItems() {
            for nutriment in allNutriments {
                add(nutrimentCode: nutriment.nameKey)
                if let view = editNutrimentView(forCode: nutriment.nameKey) {
                    if let value = nutriment.value {
                        let modifier = nutriment.modifier ?? ""
                        view.inputTextField.text = "\(modifier)\(value)".trimmingCharacters(in: .whitespaces)
                    } else {
                        view.inputTextField.text = nil
                    }
                    view.selectedUnit = nutriment.unit
                }
            }
        }

        if let lang = product.lang {
            didGetSelection(value: Language(code: lang, name: Locale.current.localizedString(forIdentifier: lang) ?? lang))
        }

        lastSavedProductInfosLabel.isHidden = true
        lastSavedNutrimentsLabel.isHidden = true
        lastSavedIngredientsLabel.isHidden = true
        lastSavedIngredientsOCRLabel.isHidden = true

        refreshNovaScore()
    }

    // swiftlint:disable cyclomatic_complexity
    private func fillForm(withPendingUploadItem pendingUploadItem: PendingUploadItem) {

        if let productName = pendingUploadItem.productName {
            productNameField.text = productName
        }

        if let brand = pendingUploadItem.brand {
            brandsField.text = brand
        }

        if let categorieTag = pendingUploadItem.categories?.first {
            if let categorie = dataManager.category(forTag: categorieTag) {
                productCategoryField.text = categorie.names.chooseForCurrentLanguage()?.value ?? categorieTag
            } else {
                productCategoryField.text = categorieTag
            }
        }

        if let quantity = pendingUploadItem.quantity {
            quantityField.text = quantity
        }

        if let packaging = pendingUploadItem.packaging {
            packagingField.text = packaging
        }

        if let ingredientsList = pendingUploadItem.ingredientsList {
            ingredientsTextField.text = ingredientsList
        }

        if let noNutritionData = pendingUploadItem.noNutritionData {
            noNutritionDataSwitch.isOn = noNutritionData == "on"
            updateNoNutritionDataSwitchVisibility(animated: false)
        }
        if let servingSize = pendingUploadItem.servingSize {
            portionSizeInputView.inputTextField.text = servingSize
        }
        if let nutritionDataPer = pendingUploadItem.nutritionDataPer {
            if let nutritionDataPer = NutritionDataPer(rawValue: nutritionDataPer) {
                switch nutritionDataPer {
                case .hundredGrams: nutritivePortionSegmentedControl.selectedSegmentIndex = 0
                case .serving: nutritivePortionSegmentedControl.selectedSegmentIndex = 1
                }
            }
        }
        for nutriment in pendingUploadItem.nutriments {
            add(nutrimentCode: nutriment.code)
            if let view = editNutrimentView(forCode: nutriment.code) {
                view.inputTextField.text = "\(nutriment.value)"
                view.selectedUnit = nutriment.unit
            }
        }

        // Set language
        didGetSelection(value: Language(code: pendingUploadItem.language, name: Locale.current.localizedString(forIdentifier: pendingUploadItem.language) ?? pendingUploadItem.language))
    }

    fileprivate func editNutrimentView(forCode: String) -> EditNutritiveValueView? {
        for arrangedSubview in nutritiveValuesStackView.arrangedSubviews {
            if let arrangedSubview = arrangedSubview as? EditNutritiveValueView {
                if arrangedSubview.nutrimentCode == forCode {
                    return arrangedSubview
                }
            }
        }
        return nil
    }
}

// MARK: - Keyboard notification handler
extension ProductAddViewController {
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        // swiftlint:disable:next force_cast
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

        // move if keyboard hide input field
        let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y ?? 0) - (activeField?.frame.size.height ?? 0)
        let collapseSpace = keyboardFrame.height - distanceToBottom
        if collapseSpace < 0 {
            // no collapse
            return
        }
        // set new offset for scroll view
        UIView.animate(withDuration: 0.3, animations: {
            // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
        })
    }

    @objc func keyboardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension ProductAddViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == productCategoryField {
            //open select category
            let selectCategoryViewController = SelectCategoryViewController(nibName: "SelectCategoryViewController", bundle: nil)
            selectCategoryViewController.dataManager = self.dataManager
            selectCategoryViewController.delegate = self
            self.navigationController?.pushViewController(selectCategoryViewController, animated: true)
            return false
        }
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }

    fileprivate func computeSaltFromSodium(sodium: Double, inUnit: String?, withModifier modifier: String?) {
        let unit = inUnit ?? "g"

        var sodiumMG = sodium

        switch unit {
        case "g": sodiumMG = sodium * 1000
        case "µg": sodiumMG = sodium / 1000
        default: break
        }

        let saltG = sodiumMG * 2.5 / 1000
        for arrangedSubview in nutritiveValuesStackView.arrangedSubviews {
            if let arrangedSubview = arrangedSubview as? EditNutritiveValueView, arrangedSubview.nutrimentCode == "salt" {
                arrangedSubview.selectedUnit = "g"
                let modif = modifier ?? ""
                arrangedSubview.inputTextField.text = "\(modif)\(saltG)"
                break
            }
        }
    }

    fileprivate func computeSodiumFromSalt(salt: Double, inUnit: String?, withModifier modifier: String?) {
        let unit = inUnit ?? "g"

        var saltG = salt

        switch unit {
        case "mg": saltG = salt / 1000
        case "µg": saltG = salt / 1000000
        default: break
        }

        let sodiumMG = saltG * 1000 / 2.5
        for arrangedSubview in nutritiveValuesStackView.arrangedSubviews {
            if let arrangedSubview = arrangedSubview as? EditNutritiveValueView, arrangedSubview.nutrimentCode == OFFJson.SodiumKey {
                arrangedSubview.selectedUnit = "mg"
                let modif = modifier ?? ""
                arrangedSubview.inputTextField.text = "\(modif)\(sodiumMG)"
                break
            }
        }
    }

    fileprivate func updateTooMuchLabel(inNutritiveView editNutritiveView: EditNutritiveValueView, forValue doubleValue: Double) {
        var doubleValueIng = doubleValue
        switch editNutritiveView.selectedUnit ?? "g" {
        case "g":
            editNutritiveView.tooMuchLabel.isHidden = doubleValueIng < 100
        case "mg":
            doubleValueIng = doubleValue / 1000
            editNutritiveView.tooMuchLabel.isHidden = doubleValueIng < 100
        case "µg":
            doubleValueIng = doubleValue / 1000000
            editNutritiveView.tooMuchLabel.isHidden = doubleValueIng < 100
        default:
            editNutritiveView.tooMuchLabel.isHidden = true
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if productInformationsTextFields.contains(textField) {
            showNotSavedIndication(label: lastSavedProductInfosLabel, key: "save-info")
        }
        if textField.isDescendant(of: nutritiveValuesStackView) {
            showNotSavedIndication(label: lastSavedNutrimentsLabel, key: "save-nutriments")

            if let editNutritiveView = textField.superviewOfClassType(EditNutritiveValueView.self) as? EditNutritiveValueView {
                if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                    if updatedString.matches(for: "^[<>~]{0,1}[0-9]*[.,]{0,1}[0-9]*$").isEmpty {
                        //do not allow input of non authorized chars
                        return false
                    }
                    if let inputValue = editNutritiveView.getInputValue(fromString: updatedString) {
                        updateTooMuchLabel(inNutritiveView: editNutritiveView, forValue: inputValue.value)
                        if editNutritiveView.nutrimentCode == OFFJson.SaltKey {
                            computeSodiumFromSalt(salt: inputValue.value, inUnit: editNutritiveView.selectedUnit, withModifier: inputValue.modifier)
                        } else if editNutritiveView.nutrimentCode == OFFJson.SodiumKey {
                            computeSaltFromSodium(sodium: inputValue.value, inUnit: editNutritiveView.selectedUnit, withModifier: inputValue.modifier)
                        }
                    }
                }
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

extension ProductAddViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        showNotSavedIndication(label: lastSavedIngredientsLabel, key: "save-ingredients")
        return true
    }

}

extension ProductAddViewController: PictureTableViewControllerDelegate {
    func didPostIngredientImage() {
        showSavingIndication(label: lastSavedIngredientsOCRLabel, key: "ocr-ingredients")
        dataManager.getIngredientsOCR(forBarcode: barcode, productLanguageCode: Bundle.main.preferredLocalizations.first ?? "en") { [weak self] (ingredients: String?, _: Error?) in
            DispatchQueue.main.async {
                if let ingredients = ingredients, !ingredients.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                    self?.ingredientsTextField.text = ingredients
                    self?.showNotSavedIndication(label: self?.lastSavedIngredientsLabel, key: "save-ingredients")
                    self?.showSavedSuccess(label: self?.lastSavedIngredientsOCRLabel, key: "ocr-ingredients")
                } else {
                    self?.showSavedError(label: self?.lastSavedIngredientsOCRLabel, key: "ocr-ingredients")
                }
            }
        }
    }
}

extension ProductAddViewController: SelectCategoryDelegate {
    func didSelect(category: Category) {
        productCategoryField.text = category.names.chooseForCurrentLanguage(defaultToFirst: true)?.value ?? category.code
        self.productCategory = category
        self.productCategoryCustomName = nil
        self.navigationController?.popToViewController(self, animated: true)
        showNotSavedIndication(label: lastSavedProductInfosLabel, key: "save-info")
    }

    func didSelect(customCategory: String) {
        productCategoryField.text = customCategory
        self.productCategory = nil
        self.productCategoryCustomName = customCategory
        self.navigationController?.popToViewController(self, animated: true)
        showNotSavedIndication(label: lastSavedProductInfosLabel, key: "save-info")
    }
}

extension ProductAddViewController: SelectNutrimentDelegate {
    func didSelect(nutriment: Nutriment) {
        add(nutrimentCode: nutriment.code)
        self.navigationController?.popToViewController(self, animated: true)
        showNotSavedIndication(label: lastSavedNutrimentsLabel, key: "save-nutriments")
    }

    func add(nutrimentCode: String) {
        if !displayedNutrimentItems.contains(nutrimentCode) {
            displayedNutrimentItems.append(nutrimentCode)
            refreshNutritiveInputsViews()
        }
    }
}

extension ProductAddViewController: PickerViewDelegate {
    func didGetSelection(value: Pickable) {
        switch value {
        case let language as Language:
            self.product.lang = language.code
            self.languageField.text = language.name
            self.refreshProductTranslatedValuesFromLang()
        default:
            // Do nothing
            return
        }
    }

    func didDismiss() {
        self.view.endEditing(true)
    }
}

extension ProductAddViewController: EditNutritiveValueViewDelegate {
    func didChangeUnit(view: EditNutritiveValueView) {
        if let inputValue = view.getInputValue() {
            updateTooMuchLabel(inNutritiveView: view, forValue: inputValue.value)

            if view.nutrimentCode == OFFJson.SaltKey {
                self.computeSodiumFromSalt(salt: inputValue.value, inUnit: view.selectedUnit, withModifier: inputValue.modifier)
            } else if view.nutrimentCode == OFFJson.SodiumKey {
                self.computeSaltFromSodium(sodium: inputValue.value, inUnit: view.selectedUnit, withModifier: inputValue.modifier)
            }
        }
    }
}
