//
//  FormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol FormTableViewControllerDelegate: class {
    func cellSizeDidChange()
}

class FormTableViewController: UITableViewController {
    var form: Form! {
        didSet {
            if oldValue != nil {
                self.tableView.reloadData()
            }
        }
    }
    let dataManager: DataManagerProtocol
    weak var delegate: ProductDetailRefreshDelegate?

    fileprivate let localizedTitle: String

    init(with form: Form, dataManager: DataManagerProtocol) {
        self.form = form
        self.dataManager = dataManager
        localizedTitle = form.title
        super.init(nibName: nil, bundle: nil)

        configureTableViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.alwaysBounceVertical = false // prevent scroll when table view fits in screen
        tableView.tableFooterView = UIView(frame: CGRect.zero) // Hide empty rows
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.cellLayoutMarginsFollowReadableWidth = false

        for cellType in form.getCellTypes() {
            if Bundle.main.path(forResource: cellType.identifier, ofType: "nib") != nil {
                tableView.register(UINib(nibName: cellType.identifier, bundle: nil), forCellReuseIdentifier: cellType.identifier)
            } else {
                tableView.register(cellType, forCellReuseIdentifier: cellType.identifier)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ververs), name: .FrontImageIsUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ververs), name: .IngredientsImageIsUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ververs), name: .NutritionImageIsUpdated, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .FrontImageIsUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .IngredientsImageIsUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .NutritionImageIsUpdated, object: nil)
        super.viewWillDisappear(animated)
    }

    func getCell(for formRow: FormRow) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! ProductDetailBaseCell // swiftlint:disable:this force_cast
        cell.configure(with: formRow, in: self)
        return cell
    }

    private func configureTableViewController() {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }

    func showLogin() {
        guard let loginVC = UserViewController.loadFromStoryboard(named: .settings) as? UserViewController else {
            return }
        loginVC.dataManager = dataManager

        let navVC = UINavigationController(rootViewController: loginVC)
        loginVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(FormTableViewController.dismissVC))
        loginVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(FormTableViewController.dismissVC))

        self.present(navVC, animated: true)
    }

    func goToEditProduct(product: Product) {
        if CredentialsController.shared.getUsername() == nil {
            self.showLogin()
            return
        }

        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: nil)
        if let addProductVC = storyboard.instantiateInitialViewController() as? ProductAddViewController {
            addProductVC.productToEdit = product
            addProductVC.dataManager = dataManager

            let navVC = UINavigationController(rootViewController: addProductVC)
            if self.responds(to: #selector(FormTableViewController.dismissVC)) {
                addProductVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(FormTableViewController.dismissVC))
            }
            if addProductVC.responds(to: #selector(ProductAddViewController.saveAll)) {
                addProductVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: addProductVC, action: #selector(ProductAddViewController.saveAll))
            }
            navVC.modalPresentationStyle = .fullScreen

            self.present(navVC, animated: true)
        }
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - TableView Data Source
extension FormTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formRow = form.rows[indexPath.row]
        return getCell(for: formRow)
    }
}

// MARK: - TableView delegate
extension FormTableViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = form.rows[indexPath.row].cellType
        return cellType.estimatedHeight
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return form.rows[indexPath.row].isCopiable
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let formRow = form.rows[indexPath.row]
        guard let value = formRow.getValueAsString() else { return }
        UIPasteboard.general.string = value
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let ingredientsAnalysisTableViewCell = cell as? ProductDetailBaseCell {
            ingredientsAnalysisTableViewCell.dismiss()
        }
    }
}

extension FormTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: localizedTitle)
    }
}

extension FormTableViewController: FormTableViewControllerDelegate {
    func cellSizeDidChange() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension FormTableViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // only open the external page when the actual text has been tapped.
        if characterRange.location + characterRange.length < textView.text.count {
            openUrlInApp(URL)
        }
        return false
    }
}

// MARK: - Refresh control

extension FormTableViewController {
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        delegate?.refreshProduct {
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
            }
        }
    }

    @objc func ververs() {
        delegate?.refreshProduct {
            DispatchQueue.main.async {
                // not sure something needs to be done
            }
        }
    }
}
