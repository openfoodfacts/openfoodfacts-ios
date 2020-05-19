//
//  LanguagesTableViewController.swift
//  OpenFoodFacts
//
//  Created by Mykola Aleshchenko on 09/05/2020.
//

import UIKit
import Foundation

extension Notification.Name {
    static let languageChanged = Notification.Name("language-changed")
}

class LanguagesTableViewController: UITableViewController {
    private let languages = Bundle.main.appLocalizations()
    private let currentLocalization = Bundle().currentLocalization
    private let cellReuseIdentifier = "languageCell"

    init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "product-add.language.toolbar-title".localized
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(languages[indexPath.row], forKey: UserDefaultsConstants.appLocalization)
        NotificationCenter.default.post(name: .languageChanged, object: nil, userInfo: nil)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let localizationCode = languages[indexPath.row]
        cell.textLabel?.text = NSLocale(localeIdentifier: localizationCode).displayName(forKey: .identifier, value: localizationCode)?.capitalized
        cell.accessoryType = currentLocalization == localizationCode ? .checkmark : .none

        return cell
    }
}
