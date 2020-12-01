//
//  HistoryTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SVProgressHUD
import NotificationBanner

struct HistoryCellId {
    static let privacy = "PrivacyCell"
    static let item = "ProductTableViewCell"
}

class HistoryTableViewController: UITableViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
    lazy var items = [Age: [HistoryItem]]()

    var showDetailsBanner: NotificationBanner!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "history.title".localized

        tableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: HistoryCellId.item)

        showDetailsBanner = NotificationBanner(title: "product-search.error-view.title".localized,
                                               subtitle: "product-search.error-view.subtitle".localized,
                                               style: .danger)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = dataManager.getHistory()
        if items.isEmpty {
            configureEmptyState()
        } else {
            configureRegularState()
        }

        tableView.reloadData()
    }

    private func configureEmptyState() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        tableView.separatorStyle = .none

        shareButton.isEnabled = false
        shareButton.tintColor = UIColor.clear

        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false

        let firstScanButton = UIButton.init(type: .system)
        firstScanButton.translatesAutoresizingMaskIntoConstraints = false
        firstScanButton.setTitle("history.first-scan.button.title".localized, for: .normal)
        firstScanButton.addTarget(self, action: #selector(requestScan), for: .touchUpInside)

        buttonContainerView.addSubview(firstScanButton)
        tableView.tableFooterView = buttonContainerView

        NSLayoutConstraint.activate([
            buttonContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            buttonContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            firstScanButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            firstScanButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor)
        ])
    }

    private func configureRegularState() {
        navigationItem.rightBarButtonItem?.isEnabled = true

        shareButton.isEnabled = true
        shareButton.tintColor = navigationController?.navigationBar.tintColor

        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = nil
    }

    @objc private func requestScan() {
        NotificationCenter.default.post(name: .requestScanning, object: nil, userInfo: nil)
    }

    @IBAction func exportHistory(_ sender: UIBarButtonItem) {
        let historyItems = Array(items.values.joined())
        guard let historyFileURL = ExportHelper().exportItemsToCSV(objects: historyItems) else {
            let alert = UIAlertController(title: "product-search.error-view.title".localized,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "alert.action.ok".localized,
                                          style: .default,
                                          handler: { _ in alert.dismiss(animated: true, completion: nil) }))

            self.present(alert, animated: true, completion: nil)
            return
        }

        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [historyFileURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func clearHistory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "history.clear.confirmation-title".localized, message: "history.clear.confirmation-message".localized, preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "history.button.clear".localized, style: .destructive) { (_) -> Void in
            self.dataManager.clearHistory()
            self.items.removeAll()
            self.configureEmptyState()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "generic.cancel".localized, style: .default) { (_) -> Void in }

        alert.addAction(cancelAction)
        alert.addAction(clearAction)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension HistoryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Item is a dictionary. The keys are values from Age.
        // There is an additional last section containing a single row with info about search history privacy.
        return items.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPrivacySection(section) {
            return 1
        } else {
            guard let age = items.key(forIndex: section) else { return 0 }
            guard let sectionItems = items[age] else { return 0 }

            return sectionItems.count
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isPrivacySection(indexPath.section) {
            return 44
        }
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = isPrivacySection(indexPath.section) ? HistoryCellId.privacy : HistoryCellId.item
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)

        guard let item = getItem(forIndex: indexPath) else { return cell }

        if id == HistoryCellId.item {
            (cell as! ProductTableViewCell).configure(withHistoryItem: item) // swiftlint:disable:this force_cast
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Last section is the privacy info
        guard !isPrivacySection(section),
            !isSectionEmpty(section),
            let age = items.key(forIndex: section) else { return nil }

        switch age {
        case .last24h:
            return "history.section-titles.last24h".localized
        case .fewDays:
            return "history.section-titles.fewDays".localized
        case .fewWeeks:
            return "history.section-titles.fewWeeks".localized
        case .fewMonths:
            return "history.section-titles.fewMonths".localized
        case .longTime:
            return "history.section-titles.longTime".localized
        }
    }

    private func isPrivacySection(_ section: Int) -> Bool {
        return section > items.count - 1
    }

    private func getItem(forIndex indexPath: IndexPath) -> HistoryItem? {
        guard let sectionAge = items.key(forIndex: indexPath.section) else { return nil }
        return items[sectionAge]?[indexPath.row]
    }

    private func isSectionEmpty(_ section: Int) -> Bool {
        guard let section = items.key(forIndex: section) else { return true }
        return items[section]?.isEmpty ?? true
    }
}

// MARK: - UITableViewDelegate

extension HistoryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isPrivacySection(indexPath.section) else { return }
        guard let item = getItem(forIndex: indexPath) else { return }

        showItem(item) {
            self.showDetailsBanner.show()
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let section = items.key(forIndex: indexPath.section),
                let historyItem = items[section]?[indexPath.row] else { return }

            items[section]?.remove(at: indexPath.row)
            dataManager.removeHistroyItem(historyItem)
            tableView.deleteRows(at: [indexPath], with: .fade)

            if isSectionEmpty(indexPath.section) {
                // Will remove section header if the section is empty
                tableView.reloadSections([indexPath.section], with: .fade)

                if dataManager.getHistory().isEmpty {
                    configureEmptyState()
                }
            }
        }
    }

    func showProductDetails(product: Product) {
        let productDetailsVC = ProductDetailViewController.loadFromStoryboard() as ProductDetailViewController
        productDetailsVC.product = product
        productDetailsVC.dataManager = dataManager

        // Store product in search history
        dataManager.addHistoryItem(product)
        if let vcs = self.navigationController {
            vcs.pushViewController(productDetailsVC, animated: true)
        }
    }

    func showItem(_ item: HistoryItem, onError: @escaping () -> Void) {
        SVProgressHUD.show()
        dataManager.getProduct(byBarcode: item.barcode, isScanning: false, isSummary: false, onSuccess: { product in
            if let product = product {
                self.showProductDetails(product: product)
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
                onError()
            }
        }, onError: { _ in
            SVProgressHUD.dismiss()
            onError()
        })
    }
}

private extension Dictionary {
    func key(forIndex index: Int) -> Age? {
        guard var keys = (Array(self.keys) as? [Age]) else { return nil }

        // Sort
        keys = keys.sorted { $0.rawValue < $1.rawValue }

        // Check emptiness and bounds
        if keys.isEmpty || index > keys.count - 1 {
            return nil
        }

        return keys[index]
    }
}
