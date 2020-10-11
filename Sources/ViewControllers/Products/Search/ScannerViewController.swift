//
//  ScannerViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import AVFoundation
import NotificationBanner
import SVProgressHUD
import FloatingPanel

class ScannerViewController: UIViewController, DataManagerClient {
    fileprivate let supportedBarcodes = [AVMetadataObject.ObjectType.upce,
                                         AVMetadataObject.ObjectType.code39,
                                         AVMetadataObject.ObjectType.code39Mod43,
                                         AVMetadataObject.ObjectType.code93,
                                         AVMetadataObject.ObjectType.code128,
                                         AVMetadataObject.ObjectType.ean8,
                                         AVMetadataObject.ObjectType.ean13,
                                         AVMetadataObject.ObjectType.pdf417,
                                         AVMetadataObject.ObjectType.itf14,
                                         AVMetadataObject.ObjectType.interleaved2of5]

    fileprivate var session = AVCaptureSession()
    fileprivate var barcodeQueue = DispatchQueue(label: "barcode queue")
    fileprivate var videoPreviewView = UIView()
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate lazy var flashButton = FlashButton()
    fileprivate lazy var overlay = TextOverlay()
    fileprivate var tapToFocusView: TapToFocusView?
    fileprivate var lastCodeScanned: String?
    fileprivate var barcodeToOpenAtStartup: String?
    fileprivate var allergenAlertShown = false
    fileprivate var showHelpInOverlayTask: DispatchWorkItem?

    var dataManager: DataManagerProtocol!
    var configResult: SessionConfigResult = .success

    fileprivate var floatingPanelController: FloatingPanelController!
    fileprivate var scannerResultController: ScannerResultViewController!
    fileprivate var scannerFloatingPanelLayout = ScannerFloatingPanelLayout()
    fileprivate let floatingLabelContainer = UIView()
    fileprivate let floatingLabel = UILabel()

    /** view used to stack informations above the floating panel. Will contain vegan / vegetarian / palm and alerts regarding non complete products */
    fileprivate let floatingTopContainer = UIStackView()
    fileprivate let ingredientsAnalysisFloatingContainer = UIStackView()

    /// System button displayed next to the ingredients analysis icon (if any), which points to the settings of the ingredient analysis.
    var ingredientAnalysisSettingsButton: UIButton?

// MARK: - initialisers

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "product-scanner.view-title".localized

        lastCodeScanned = nil
        allergenAlertShown = false

        // If running for a snapshot, don’t initialize the camera
        if !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            checkCameraPermissions()
            configureVideoView()
            configureSession()
            configureOverlay()
            configureFlashView()
            configureTapToFocus()
        } else {
            configureVideoView()
            configureOverlay()
        }
        floatingLabel.textAlignment = .center
        floatingLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            floatingLabel.textColor = .label
        } else {
            floatingLabel.textColor = .white
        }

        if #available(iOS 13.0, *) {
            floatingLabelContainer.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.66)
        } else {
            floatingLabelContainer.backgroundColor = UIColor.black.withAlphaComponent(0.66)
        }
        floatingLabelContainer.addSubview(floatingLabel)
        floatingLabelContainer.isHidden = true

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: floatingLabel, attribute: .bottom, relatedBy: .equal, toItem: floatingLabelContainer, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: floatingLabel, attribute: .top, relatedBy: .equal, toItem: floatingLabelContainer, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: floatingLabel, attribute: .leading, relatedBy: .equal, toItem: floatingLabelContainer, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: floatingLabel, attribute: .trailing, relatedBy: .equal, toItem: floatingLabelContainer, attribute: .trailing, multiplier: 1, constant: 8)
        ])

        self.view.addSubview(floatingLabelContainer)
        floatingLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false

        configureFloatingPanel()

        // set the useragent for the scan URL calls from this app
        setUserAgent()


        floatingTopContainer.distribution = .fillProportionally
        floatingTopContainer.axis = .vertical
        floatingTopContainer.addArrangedSubview(floatingLabelContainer)
        floatingTopContainer.addArrangedSubview(ingredientsAnalysisFloatingContainer)

        self.view.addSubview(floatingTopContainer)
        floatingTopContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: floatingTopContainer, attribute: .bottom, relatedBy: .equal, toItem: floatingPanelController.surfaceView, attribute: .top, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: floatingTopContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: floatingTopContainer, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -16)
        ])

        ingredientsAnalysisFloatingContainer.spacing = CGFloat(2.0)

        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 35)
            if let image = UIImage.init(systemName: "square.and.pencil", withConfiguration: configuration ) {
                ingredientAnalysisSettingsButton = UIButton.systemButton(with: image, target: self, action: #selector(self.showIngredientsSettings))
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable the scanner when launching in snapshot mode
        if !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            configureVideoPreviewLayer()
            resetOverlay()

            switch configResult {
            case .success:
                session.startRunning()
            case .noPermissions:
                requestPermissions()
            case .failed:
                returnToRootController()
            }
        } else {
            configureFakePreviewLayer()
            resetOverlay()
        }

        if let barcodeToOpenAtStartup = barcodeToOpenAtStartup {
            self.lastCodeScanned = barcodeToOpenAtStartup
            self.barcodeToOpenAtStartup = nil
            self.getProduct(barcode: barcodeToOpenAtStartup, isSummary: true, createIfNeeded: false)
        } else {
            self.floatingPanelController.move(to: .hidden, animated: false)
        }

        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.isNavigationBarHidden = false

        session.stopRunning()
        showHelpInOverlayTask?.cancel()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.lastCodeScanned = nil
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.videoPreviewLayer?.connection?.videoOrientation = self.transformOrientation()
            self.videoPreviewLayer?.frame = self.view.bounds
        }, completion: nil)
    }

    @objc func showIngredientsSettings() {
        let alertsVC = IngredientsAnalysisSettingsTableViewController()
        alertsVC.dataManager = dataManager
        self.navigationController?.pushViewController(alertsVC, animated: true)
    }

    fileprivate func transformOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
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
            userAgentString += "; build " +  validBuild + " - scan"
        }
        UserDefaults.standard.register(defaults: ["UserAgent": userAgentString])
    }

    fileprivate func configureVideoView() {
        videoPreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(videoPreviewView)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[videoPreviewView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["videoPreviewView": videoPreviewView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[videoPreviewView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["videoPreviewView": videoPreviewView]))
    }

    // Display this layer when performing snapshot tests : it will display an image from OpenFoodFacts.org static reposistory
    private func configureFakePreviewLayer() {
        self.dataManager.getMockBarcodeImage(forLocale: Locale.current, onSuccess: { [weak self] image in
            let imageView = UIImageView(image: image)
            self?.videoPreviewView.addSubview(imageView)
            }, onError: { error in
            AnalyticsManager.record(error: error)
        })
    }

    private func configureVideoPreviewLayer() {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = self.view.layer.bounds

        self.videoPreviewLayer = videoPreviewLayer
        self.videoPreviewView.layer.addSublayer(videoPreviewLayer)
        // This needed to start out with the right orientation in landscape
        // Unclear why this works at all
        if let previewLayerConnection = self.videoPreviewLayer?.connection, previewLayerConnection.isVideoOrientationSupported {
            previewLayerConnection.videoOrientation = transformOrientation()
            //self.videoPreviewLayer?.frame = self.view.layer.bounds
        }
    }

    fileprivate func configureSession() {
        if configResult != .success {
            return
        }

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            configResult = .failed
            handleNoCamera()
            return
        }

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            session.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: barcodeQueue)
            captureMetadataOutput.metadataObjectTypes = supportedBarcodes
        } catch {
            configResult = .failed
            AnalyticsManager.record(error: error)
            return
        }
    }

    fileprivate func configureOverlay() {
        self.view.addSubview(overlay)
        overlay.accessibilityIdentifier = AccessibilityIdentifiers.Scan.overlayView

        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: overlay, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[overlay]-0-|", options: [], metrics: nil, views: ["overlay": overlay])

        self.view.addConstraints(constraints)

        resetOverlay()
    }

    fileprivate func configureFlashView() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            flashButton.translatesAutoresizingMaskIntoConstraints = false
            flashButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFlashButton(_:))))
            self.view.addSubview(flashButton)

            let bottomConstraint = NSLayoutConstraint(item: self.overlay, attribute: .bottom, relatedBy: .equal, toItem: flashButton, attribute: .top, multiplier: 1, constant: -16)
            let leftConstraint = NSLayoutConstraint(item: flashButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 16)

            self.view.addConstraints([bottomConstraint, leftConstraint])
        }
    }

    fileprivate func resetOverlay() {
        DispatchQueue.main.async {
            self.overlay.setText("product-scanner.overlay.user-help".localized)
            self.showHelpInOverlayTask?.cancel()
            self.showScanHelpInstructions()
        }
    }

    fileprivate func showScanHelpInstructions() {
        let task = DispatchWorkItem { [weak self] in
            guard self != nil else { return }

            if self?.lastCodeScanned == nil {
                self?.overlay.setText("product-scanner.overlay.extended-user-help".localized)
                self?.scannerFloatingPanelLayout.canShowDetails = true
                self?.scannerResultController.status = .manualBarcode
                self?.floatingPanelController.move(to: .tip, animated: true)
                self?.showIngredientsAnalysisFloatingIfNeeded()
            } else {
                self?.showScanHelpInstructions()
            }
        }

        // Wait 10 seconds before showing some help content and the possibility to input a barcode manually.
        // In snapshot mode, we will do that instantly
        self.showHelpInOverlayTask = task
        if UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: task)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: task)
        }
    }

    fileprivate func configureTapToFocus() {
        self.videoPreviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToFocus(_:))))
    }

    fileprivate func configureFloatingPanel() {

        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.contentMode = .fitToBounds

        // Add the floating panel view to the controller's view on top of other views.
        self.view.addSubview(floatingPanelController.view)
        floatingPanelController.view.frame = self.view.bounds

        // In addition, Auto Layout constraints are highly recommended.
        // Constraint the fpc.view to all four edges of your controller's view.
        // It makes the layout more robust on trait collection change.
        floatingPanelController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          floatingPanelController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          floatingPanelController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          floatingPanelController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          floatingPanelController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
        ])

        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        // swiftlint:disable:next force_cast
        scannerResultController = (storyboard.instantiateViewController(withIdentifier: "ScannerResultViewController") as! ScannerResultViewController)
        floatingPanelController.set(contentViewController: scannerResultController)

        floatingPanelController.surfaceView.backgroundColor = .clear
        floatingPanelController.surfaceView.cornerRadius = 9.0
        floatingPanelController.surfaceView.shadowHidden = false
        // Add a gesture to hide the summaryView
        let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideSummaryView(_:)))
        gestureDown.numberOfTouchesRequired = 1
        gestureDown.direction = .down
        floatingPanelController.surfaceView.addGestureRecognizer(gestureDown)
        floatingPanelController.surfaceView.isUserInteractionEnabled = true

        floatingPanelController.addPanel(toParent: self)

        scannerResultController.manualBarcodeInputView.delegate = self
    }

    private func handleNoCamera() {
        let error = NSError(domain: "ScannerViewControllerErrorDomain", code: 1, userInfo: ["errorType": "No camera found"])
        AnalyticsManager.record(error: error)
    }
}

// MARK: - AVCapture delegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            return
        }

        if let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, supportedBarcodes.contains(metadataObject.type), let barcode = metadataObject.stringValue {

            if self.dataManager.isInvalid(barcode: barcode) {
                // barcode is invalid, we just ignore as if nothing was scanned
                return
            }

            if lastCodeScanned == nil || (lastCodeScanned != nil && lastCodeScanned != barcode) {
                resetOverlay()
                allergenAlertShown = false
                DispatchQueue.main.async {
                    self.floatingLabelContainer.isHidden = true
                }
                lastCodeScanned = barcode
                getProduct(barcode: barcode, isSummary: true)
            }
        }
    }

    /// when isSummary is true, only a few fields of the products are downloaded, and when done, this methods calls itself with isSummary=false
    func getProduct(barcode: String, isSummary: Bool, createIfNeeded: Bool = true) {
        scannerFloatingPanelLayout.canShowDetails = false
        DispatchQueue.main.async {
            self.floatingPanelController.move(to: .tip, animated: true)

            var hasOfflineSave = false

            if isSummary {
                if let offlineProduct = self.dataManager.getOfflineProduct(forCode: barcode) {
                    self.scannerResultController.status = .hasOfflineData(product: offlineProduct)
                    self.showAllergensFloatingLabelIfNeeded()
                    self.showIngredientsAnalysisFloatingIfNeeded()
                    hasOfflineSave = true
                }
            }

            if isSummary && !hasOfflineSave {
                self.scannerResultController.status = .loading(barcode: barcode)
            }

            self.dataManager.getProduct(byBarcode: barcode, isScanning: true, isSummary: isSummary, onSuccess: { [weak self] response in
                self?.handleGetProductSuccess(barcode, response, isSummary: isSummary, createIfNeeded: createIfNeeded)

                if response != nil, isSummary {
                    self?.getProduct(barcode: barcode, isSummary: false)
                }

                }, onError: { [weak self] error in
                    if isOffline(errorCode: (error as NSError).code) {
                        if hasOfflineSave == false {
                            // Assume product does not exist and store locally for later upload
                            self?.handleGetProductSuccess(barcode, nil, isSummary: isSummary, createIfNeeded: createIfNeeded)
                        }
                    } else {
                        DispatchQueue.main.async {
                            StatusBarNotificationBanner(title: "product-scanner.barcode.error".localized, style: .danger).show()
                            self?.scannerResultController.status = .waitingForScan
                        }
                        self?.lastCodeScanned = nil
                    }
            })
        }
    }

    fileprivate func showAllergenAlertIfNeeded(forProduct product: Product) {
        guard let productAllergens = product.allergens else {
            return
        }

        let allergensAlerts = dataManager.listAllergies()
        let allergens = allergensAlerts.map { $0 }.filter { (allergen: Allergen) -> Bool in
            for productAllergen in productAllergens where productAllergen.languageCode + ":" + productAllergen.value == allergen.code {
                return true
            }
            return false
        }

        if allergens.isEmpty == false {
            let names = allergens.compactMap { $0.names.chooseForCurrentLanguage()?.value }
                .joined(separator: ", ")

            let alert = UIAlertController(title: "⚠️ " + "product-detail.ingredients.allergens-alert.title".localized, message: names, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }

    private func handleGetProductSuccess(_ barcode: String, _ product: Product?, isSummary: Bool, createIfNeeded: Bool = true) {
        DispatchQueue.main.async {
            if let product = product {
                if isSummary {
                    self.scannerResultController.status = .hasSummary(product: product)
                } else {
                    self.scannerFloatingPanelLayout.canShowDetails = true
                    self.dataManager.addHistoryItem(product)
                    self.scannerResultController.status = .hasProduct(product: product, dataManager: self.dataManager)
                    if self.allergenAlertShown == false {
                        self.allergenAlertShown = true
                        self.showAllergenAlertIfNeeded(forProduct: product)
                    }
                }
                self.showAllergensFloatingLabelIfNeeded()
                self.showIngredientsAnalysisFloatingIfNeeded()
            } else {
                if createIfNeeded == true {
                    self.addNewProduct(barcode)
                }
                self.scannerResultController.status = .waitingForScan
                self.floatingLabelContainer.isHidden = true
                self.ingredientsAnalysisFloatingContainer.isHidden = true
            }
        }
    }

    fileprivate func showAllergensFloatingLabelIfNeeded() {
        if dataManager.listAllergies().isEmpty {
            self.floatingLabelContainer.isHidden = true
            return
        }
        switch scannerResultController.status {
        case .hasOfflineData:
            self.floatingLabel.text = "⚠️ " + "product-detail.ingredients.allergens-list.offline-product".localized
            self.floatingLabelContainer.isHidden = false
        case .hasSummary(let product):
            self.floatingLabel.text = "⚠️ " + "product-detail.ingredients.allergens-list.missing-infos".localized
            if product.states?.contains("en:ingredients-to-be-completed") == true {
                self.floatingLabelContainer.isHidden = self.floatingPanelController.position != .tip
            } else {
                self.floatingLabelContainer.isHidden = true
            }
        case .hasProduct(let product, _):
            self.floatingLabel.text = "⚠️ " + "product-detail.ingredients.allergens-list.missing-infos".localized
            if product.states?.contains("en:ingredients-to-be-completed") == true {
                self.floatingLabelContainer.isHidden = self.floatingPanelController.position != .tip
            } else {
                self.floatingLabelContainer.isHidden = true
            }
        default:
            self.floatingLabelContainer.isHidden = true
        }
    }

    fileprivate func showIngredientsAnalysisFloatingIfNeeded() {
        self.ingredientsAnalysisFloatingContainer.arrangedSubviews.forEach {
            if let view = $0 as? IngredientsAnalysisView {
                view.removeGestureRecognizer()
            }
        }
        self.ingredientsAnalysisFloatingContainer.removeAllViews()
        self.ingredientsAnalysisFloatingContainer.isHidden = true

        switch scannerResultController.status {
        case .hasSummary(let product), .hasProduct(let product, _):
            let analysisDetails = dataManager.ingredientsAnalysis(forProduct: product)

            if !analysisDetails.isEmpty {
                analysisDetails.forEach { (iad: IngredientsAnalysisDetail) in
                    let analysisView = IngredientsAnalysisView.loadFromNib()
                    analysisView.configure(detail: iad, missingIngredients: product.states?.contains("en:ingredients-to-be-completed") == true, ingredientsList: product.ingredientsListAnalysis)
                    analysisView.openProductEditHandler = { [weak self] in
                        self?.goToEditProduct(product: product)
                    }
                    analysisView.configureGestureRecognizer()
                    self.ingredientsAnalysisFloatingContainer.addArrangedSubview(analysisView)
                    
                }
                // add a button, which points to the ingredient analysis settings.
                if let button = ingredientAnalysisSettingsButton {
                    self.ingredientsAnalysisFloatingContainer.addArrangedSubview(button)
                }
                self.ingredientsAnalysisFloatingContainer.addArrangedSubview(UIView())
                self.ingredientsAnalysisFloatingContainer.isHidden = false
            } else {
                self.ingredientsAnalysisFloatingContainer.isHidden = true
            }
        default:
            self.ingredientsAnalysisFloatingContainer.isHidden = true
        }
    }
}

// MARK: - Gesture recognizers
extension ScannerViewController {
    @objc func didTapFlashButton(_ gesture: UITapGestureRecognizer) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            try device.lockForConfiguration()
            switch flashButton.state {
            case .on:
                flashButton.state = .off
                device.torchMode = .off
            case .off:
                flashButton.state = .on
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    AnalyticsManager.record(error: error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            AnalyticsManager.record(error: error)
        }
    }

    @objc func didTapToFocus(_ gesture: UITapGestureRecognizer) {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.isFocusPointOfInterestSupported, let videoPreviewLayer = self.videoPreviewLayer {
            let touchPoint = gesture.location(in: self.videoPreviewView)

            let tapToFocusView = self.tapToFocusView ?? TapToFocusView()

            if self.tapToFocusView == nil {
                self.tapToFocusView = tapToFocusView
                self.videoPreviewView.addSubview(tapToFocusView)
            }

            tapToFocusView.updateCenter(touchPoint)

            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
            } catch {
                AnalyticsManager.record(error: error)
            }
        }
    }
}

// MARK: - Navigation

extension ScannerViewController {
    func addNewProduct(_ barcode: String) {
        turnOffFlash()

        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: nil)
        if let addProductVC = storyboard.instantiateInitialViewController() as? ProductAddViewController {
            var newProduct = Product()
            newProduct.barcode = barcode
            // set the main language of the product to the language of the device
            newProduct.lang = Locale.current.languageCode ?? "en"
            addProductVC.productToEdit = newProduct

            addProductVC.dataManager = dataManager
            self.barcodeToOpenAtStartup = barcode
            let navVC = UINavigationController(rootViewController: addProductVC)
            addProductVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ScannerViewController.dismissVC))
            addProductVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: addProductVC, action: #selector(ProductAddViewController.saveAll))
            navVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(addProductVC, animated: true)
        }
    }

    func goToEditProduct(product: Product) {
        if CredentialsController.shared.getUsername() == nil {
            guard let loginVC = UserViewController.loadFromStoryboard(named: .settings) as? UserViewController else {
                return }
            loginVC.dataManager = dataManager
            //loginVC.delegate = self

            let navVC = UINavigationController(rootViewController: loginVC)
            loginVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ScannerViewController.dismissModalVC))
            loginVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ScannerViewController.dismissModalVC))

            self.present(navVC, animated: true)

            return
        }

        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: nil)
        if let addProductVC = storyboard.instantiateInitialViewController() as? ProductAddViewController {
            addProductVC.productToEdit = product
            addProductVC.dataManager = dataManager

            let navVC = UINavigationController(rootViewController: addProductVC)
            if self.responds(to: #selector(ScannerViewController.dismissVC)) {
                addProductVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ScannerViewController.dismissVC))
            }
            if addProductVC.responds(to: #selector(ProductAddViewController.saveAll)) {
                addProductVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: addProductVC, action: #selector(ProductAddViewController.saveAll))
            }
            navVC.modalPresentationStyle = .fullScreen

            self.present(navVC, animated: true)
        }
    }

    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func dismissModalVC() {
        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func turnOffFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if flashButton.state == .on {
            do {
                try device.lockForConfiguration()
                flashButton.state = .off
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                AnalyticsManager.record(error: error)
            }
        }
    }
}

// MARK: - Permissions

extension ScannerViewController {
    enum SessionConfigResult {
        case success, noPermissions, failed
    }

    private func checkCameraPermissions() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.configResult = .failed
            returnToRootController()
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            barcodeQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.configResult = .failed
                }
                self.barcodeQueue.resume()
            })
        default:
            self.configResult = .noPermissions
        }
    }

    private func requestPermissions() {
        let title = "product-scanner.permissions.noPermissions.title".localized
        let message = "product-scanner.permissions.noPermissions.message".localized
        let actionTitle = "product-scanner.permissions.noPermissions.action.title".localized

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func returnToRootController() {
        let title = "product-scanner.permissions.failed.title".localized
        let message = "product-scanner.permissions.failed.message".localized
        let actionTitle = "product-scanner.permissions.failed.action.title".localized

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))

        #if !DEBUG
            self.present(alert, animated: true, completion: nil)
        #endif
    }
}

// MARK: - FloatingPanel delegate

extension ScannerViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return scannerFloatingPanelLayout
    }

    func floatingPanelDidChangePosition(_ floatingPanelVC: FloatingPanelController) {
        let isTip = floatingPanelVC.position == .tip

        UIView.animate(withDuration: 0.2) {
            self.floatingTopContainer.alpha = isTip ? 1 : 0
        }

        if floatingPanelVC.position != .full {
            self.view.endEditing(true)
        }
        self.showAllergensFloatingLabelIfNeeded()
    }

}

// MARK: - ManualBarcodeInput delegate
extension ScannerViewController: ManualBarcodeInputDelegate {
    func didStartEditing() {
        scannerFloatingPanelLayout.canShowDetails = true
        floatingPanelController.move(to: FloatingPanelPosition.full, animated: true)
    }

    func didEndEditing() {
        scannerFloatingPanelLayout.canShowDetails = false
        floatingPanelController.move(to: FloatingPanelPosition.tip, animated: true)
    }

    func didTapSearch() {
        guard let enteredBarcode = scannerResultController.manualBarcodeInputView.barcodeTextField.text else {
            return
        }
        let barcode = enteredBarcode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard !barcode.isEmpty else {
            return
        }
        self.lastCodeScanned = barcode
        allergenAlertShown = false
        self.getProduct(barcode: barcode, isSummary: true)
    }
}

class ScannerFloatingPanelLayout: FloatingPanelLayout {

    fileprivate var canShowDetails: Bool = false

    public var initialPosition: FloatingPanelPosition {
        return .hidden
    }

    public var supportedPositions: Set<FloatingPanelPosition> {
        return canShowDetails ? [.full, .tip] : [.tip]
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .tip: return 112.0 + 16.0
        default: return nil
        }
    }
}

// MARK: - Gesture recognizers
extension ScannerViewController {

    @objc func hideSummaryView(_ sender: UISwipeGestureRecognizer) {
        floatingPanelController.move(to: FloatingPanelPosition.hidden, animated: true)
    }

}
