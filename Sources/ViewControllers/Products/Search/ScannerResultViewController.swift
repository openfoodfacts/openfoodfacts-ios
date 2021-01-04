//
//  ScannerResultViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 24/01/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import FloatingPanel

enum ScannerResultStatusEnum {
    case waitingForScan
    case loading(barcode: String)
    case hasOfflineData(product: RealmOfflineProduct)
    case hasSummary(product: Product)
    case hasProduct(product: Product, dataManager: DataManagerProtocol)
    case manualBarcode
}

class ScannerResultViewController: UIViewController {

    @IBOutlet weak var statusIndicatorLabel: UILabel!

    @IBOutlet weak var topSummaryView: ScanProductSummaryView!
    @IBOutlet weak var manualBarcodeInputView: ManualBarcodeInputView!
    @IBOutlet weak var productDetailsContainer: UIView!

    private var product: Product?

    var status: ScannerResultStatusEnum = .waitingForScan {
        didSet {
            updateSummaryDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        topSummaryView.backgroundColor = UIColor.clear
        productDetailsContainer.backgroundColor = UIColor.clear

        updateSummaryDisplay()
    }

    fileprivate func updateSummaryDisplay() {

        topSummaryView.isHidden = true
        statusIndicatorLabel.isHidden = true
        manualBarcodeInputView.isHidden = true
        productDetailsContainer.isHidden = true

        switch status {

        case .waitingForScan:
            statusIndicatorLabel.text = "product-scanner.overlay.user-help".localized
            statusIndicatorLabel.isHidden = false

        case .loading(let barcode):
            statusIndicatorLabel.text = barcode + "\n" + "product-scanner.search.status".localized
            statusIndicatorLabel.isHidden = false

        case .hasOfflineData(let realmProduct):
            // reset the view visibility after succesful scan
            updateSummaryVisibility(for: realmProduct)

        case .hasSummary(let product):
            self.product = product
            // reset the view visibility after succesful scan
            updateSummaryVisibility(for: product)

        case .hasProduct(let product, let dataManager):
            self.product = product
            updateSummaryVisibility(for: product)
            updateDetailsVisibility(forProduct: product, withDataManager: dataManager)

        case .manualBarcode:
            manualBarcodeInputView.barcodeTextField.text = nil
            manualBarcodeInputView.isHidden = false
        }
    }

    fileprivate func updateSummaryVisibility(for realmproduct: RealmOfflineProduct) {
        let adaptor = ScanProductSummaryViewAdaptorFactory.makeAdaptor(from: realmproduct, delegate: self)
        topSummaryView.setup(with: adaptor)
        topSummaryView.isHidden = false
    }

    fileprivate func updateSummaryVisibility(for product: Product) {
        let adaptor = ScanProductSummaryViewAdaptorFactory.makeAdaptor(from: product, delegate: self)
        topSummaryView.setup(with: adaptor)
        topSummaryView.isHidden = false
    }

    fileprivate func updateDetailsVisibility(forProduct product: Product, withDataManager dataManager: DataManagerProtocol) {
        let storyboard = UIStoryboard(name: String(describing: ProductDetailViewController.self), bundle: nil)
        // swiftlint:disable:next force_cast
        let productDetailVC = storyboard.instantiateInitialViewController() as! ProductDetailViewController
        productDetailVC.product = product
        productDetailVC.dataManager = dataManager
        productDetailVC.hideSummary = true

        self.addChild(productDetailVC)
        self.productDetailsContainer.addSubview(productDetailVC.view)

        productDetailVC.view.translatesAutoresizingMaskIntoConstraints = false
        productDetailVC.view.topAnchor
            .constraint(equalTo: productDetailsContainer.topAnchor).isActive = true
        productDetailVC.view.bottomAnchor
            .constraint(equalTo: productDetailsContainer.bottomAnchor).isActive = true
        productDetailVC.view.leadingAnchor
            .constraint(equalTo: productDetailsContainer.leadingAnchor).isActive = true
        productDetailVC.view.trailingAnchor
            .constraint(equalTo: productDetailsContainer.trailingAnchor).isActive = true

        productDetailVC.didMove(toParent: self)

        self.productDetailsContainer.isHidden = false
    }

}

extension ScannerResultViewController: ScanProductSummaryViewProtocol {

    func scanProductSummaryViewButtonTapped(_ sender: ScanProductSummaryView, button: UIButton) {
        if let parent = self.parent as? FloatingPanelController,
            let svc = parent.delegate as? ScannerViewController,
            let validProduct = product {
                svc.goToEditProduct(product: validProduct)
        }
    }
}
