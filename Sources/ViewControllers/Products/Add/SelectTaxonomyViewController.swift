//
//  SelectTaxonomyViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RealmSwift

class SelectTaxonomyViewController<T: Object>: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var dataManager: DataManagerProtocol!

    var results: Results<T>?
    var resultsWithEmptyNames: Results<T>?
    var observeToken: NotificationToken?

    var allowCustomEntry: Bool = false

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: .UIKeyboardWillHide, object: nil)

        searchBar.becomeFirstResponder()

        refreshResults()
    }

    override func viewWillDisappear(_ animated: Bool) {
        observeToken = nil

        let center = NotificationCenter.default
        center.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

        super.viewWillDisappear(animated)
    }

    @objc func keyboardWillBeShown(note: Notification) {
        let userInfo = note.userInfo
        // swiftlint:disable:next force_cast
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillBeHidden(note: Notification) {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }

    func search(query: String?) -> Results<T>? {
        return dataManager.objectSearch(forQuery: query, ofClass: T.self)
    }

    func refreshResults(query: String? = nil) {
        results = search(query: query)
        resultsWithEmptyNames = results?.filter("mainName == %@", "")
            .sorted(byKeyPath: "mainName", ascending: true)
        results = results?.filter("mainName != %@", "")
            .sorted(byKeyPath: "mainName", ascending: true)

        observeToken = results?._observe({ [weak self] (_) in
            self?.tableView.reloadData()
        })
        self.tableView.reloadData()

        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshResults(query: searchText)
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return allowCustomEntry ? 3 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return results?.count ?? 0
        case 1: return resultsWithEmptyNames?.count ?? 0
        case 2:
            return (searchBar.text ?? "").isEmpty == false ? 1 : 0
        default: return 0
        }
    }

    /// should be overrident
    func title(forItem: T) -> String {
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier")!

        cell.textLabel?.text = ""
        switch indexPath.section {
        case 0:
            if let item = results?[indexPath.row] {
                cell.textLabel?.text = title(forItem: item)
            }
        case 1:
            if let item = resultsWithEmptyNames?[indexPath.row] {
                cell.textLabel?.text = title(forItem: item)
            }
        case 2:
            cell.textLabel?.text = searchBar.text
        default:
            cell.textLabel?.text = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
