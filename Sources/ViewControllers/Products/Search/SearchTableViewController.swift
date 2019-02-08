//
//  SearchTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import CoreGraphics
import Fabric
import Crashlytics

// MARK: - UIViewController

class SearchTableViewController: UITableViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!

    var searchController: UISearchController!
    var queryRequestWorkItem: DispatchWorkItem?
    var tapGestureRecognizer: UITapGestureRecognizer?
    var state = State.initial {
        didSet {
            switch state {
            case .initial: tableView.backgroundView = initialView
            case .loading: tableView.backgroundView = loadingView
            case .empty: tableView.backgroundView = emptyView
            case .content: tableView.backgroundView = nil
            case .error: tableView.backgroundView = errorView
            }
            self.tableView.reloadData()
        }
    }
    weak var delegate: SearchViewControllerDelegate?

    // Background views
    // swiftlint:disable:next force_cast
    lazy var initialView = Bundle.main.loadNibNamed("InitialView", owner: self, options: nil)!.first as! UIView
    lazy var loadingView: UIView = LoadingView(frame: self.view.bounds)
    lazy var emptyView: UIView = EmptyView(frame: self.view.bounds)
    lazy var errorView: UIView = ErrorView(frame: self.view.bounds)

    /* When the user searches a product by barcode and it's found, the product's detail view is loaded.
     If the user loads taps the back button, after presenting the search view the app goes back to the product's detail view again.
     This boolean breaks that loop. */
    fileprivate var wasSearchBarEdited = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureSearchController()
        configureGestureRecognizers()
    }

    fileprivate func configureTableView() {
        tableView.backgroundView = initialView // State.initial background view
        tableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoadingCell.self))

        tableView.rowHeight = 100
    }

    fileprivate func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "product-search.search-placeholder".localized
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }

        let searchField = searchController.searchBar.value(forKey: "_searchField") as? UITextField
        searchField?.isAccessibilityElement = true
        searchField?.accessibilityIdentifier = AccessibilityIdentifiers.productSearchBar
    }

    fileprivate func configureGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTableViewBackground(_:)))
        self.tapGestureRecognizer = tap
    }
}

// MARK: - UITableViewDataSource

extension SearchTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch state {
        case .content:
            tableView.separatorStyle = .singleLine
            tableView.isScrollEnabled = true

            return 1
        default:
            tableView.separatorStyle = .none
            tableView.isScrollEnabled = false

            if let tap = tapGestureRecognizer {
                tableView.backgroundView?.addGestureRecognizer(tap)
            }

            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let .content(response) = state else { return 0 }
        return responseHasMorePages(response) ? response.products.count + 1 : response.products.count // +1 for the loading cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .content(response) = state else { return UITableViewCell() }

        if responseHasMorePages(response) && tableView.lastIndexPath == indexPath {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell // swiftlint:disable:this force_cast

            cell.configure(withProduct: response.products[indexPath.row])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let .content(response) = state else { return }

        if response.products.count == indexPath.row + 5, responseHasMorePages(response) {
            getProducts(page: response.page + 1, withQuery: response.query)
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .content(response) = state else { return }
        delegate?.showProductDetails(product: response.products[indexPath.row])
    }
}

// MARK: - UISearchResultsUpdating

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        queryRequestWorkItem?.cancel()
        if let query = searchController.searchBar.text, !query.isEmpty, wasSearchBarEdited {
            state = .loading
            let request = DispatchWorkItem { [weak self] in
                self?.getProducts(page: 1, withQuery: query)
            }
            queryRequestWorkItem = request
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: request)
            wasSearchBarEdited = false
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        wasSearchBarEdited = true
        if searchText.isEmpty { // x button was tapped or text was deleted
            clearResults()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearResults()
    }

    fileprivate func clearResults() {
        state = .initial
    }
}

// MARK: - Data source

extension SearchTableViewController {
    func getProducts(page: Int, withQuery query: String) {
        dataManager.getProducts(for: query, page: page, onSuccess: { response in
            switch self.state {
            case .content(let oldResponse) where oldResponse.query == query: // Append new products to existing response
                oldResponse.products.append(contentsOf: response.products)
                oldResponse.page = response.page
                oldResponse.pageSize = response.pageSize
                self.state = .content(oldResponse)
            case .content(let oldResponse) where oldResponse.query != query:
                self.state = .content(response)
            case .loading: // Got new response
                if response.totalProducts == 0 {
                    self.state = .empty
                } else {
                    self.state = .content(response)
                }
            default:
                // Do nothing, this method should only be called when searching a new query or fetching a new page for the previous query
                return
            }
        }, onError: { error in
            if (error as NSError).code == NSURLErrorCancelled {
                // Ignore, a newer request cancelled this one
            } else {
                self.state = .error(error)
            }
        })
    }
}

// MARK: - Gesture recognizers

extension SearchTableViewController {
    @objc func didTapTableViewBackground(_ sender: UITapGestureRecognizer) {
        // When the search bar has no text and the user taps the background view of the table view,
        // ask the search bar to resign focus so it goes back to it's begining state and the keyboard gets dismissed
        if searchController.isActive {
            switch state {
            case .content:
                return
            default:
                if let text = searchController.searchBar.text, text.isEmpty {
                    searchController.searchBar.resignFirstResponder()
                }
            }
        }
    }
}

// MARK: - Private functions

private extension SearchTableViewController {
    func responseHasMorePages(_ response: ProductsResponse) -> Bool {
        return response.products.count < response.totalProducts
    }
}
