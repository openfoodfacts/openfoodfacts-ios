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

class SearchTableViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var searchController: UISearchController!
    fileprivate var emptyTableView: UIView!
    fileprivate var productsResponse: ProductsResponse?
    fileprivate var queryRequestWorkItem: DispatchWorkItem?
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer?
    
    /* When the user searches a product by barcode and it's found, the product's detail view is loaded.
     If the user loads taps the back button, after presenting the search view the app goes back to the product's detail view again.
     This boolean breaks that loop. */
    fileprivate var wasSearchBarEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyTableView = Bundle.main.loadNibNamed("EmptyProductsView", owner: self, options: nil)!.first as! UIView
        
        configureTableView()
        configureSearchController()
        configureNavigationBar()
        configureGestureRecognizers()
    }
    
    fileprivate func configureTableView() {
        tableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        
        tableView.rowHeight = 100
    }
    
    fileprivate func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("product-search.search-placeholder", comment: "Placeholder for the product search bar")
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    fileprivate func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barcode"), style: .plain, target: self, action: #selector(scanBarcode))
    }
    
    fileprivate func configureGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTableViewBackground(_:)))
        self.tapGestureRecognizer = tap
    }
}

// MARK: - UITableViewDataSource

extension SearchTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let response = productsResponse, let products = response.products, !products.isEmpty {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            tableView.isScrollEnabled = true
            
            return 1
        } else {
            tableView.backgroundView = emptyTableView
            tableView.separatorStyle = .none
            tableView.isScrollEnabled = false
            
            if let tap = tapGestureRecognizer {
                tableView.backgroundView?.addGestureRecognizer(tap)
            }
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = productsResponse, let products = response.products {
            return products.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        
        if let response = productsResponse, let products = response.products {
            cell.configure(withProduct: products[indexPath.row])
            
            if products.count == indexPath.row + 1, let pageString = response.page, let page = Int(pageString), let count = response.count, products.count < count {
                getProducts(fromService: ProductService(), page: page + 1)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let products = productsResponse?.products {
            showProductDetails(product: products[indexPath.row])
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        queryRequestWorkItem?.cancel()
        
        if let query = searchController.searchBar.text, !query.isEmpty, wasSearchBarEdited {
            let request = DispatchWorkItem { [weak self] in
                self?.getProducts(fromService: ProductService() ,page: 1, withQuery: query)
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
        productsResponse = nil
        tableView.reloadData()
    }
}

// MARK: - Data source

extension SearchTableViewController {
    
    func getProducts(fromService service: ProductService, page: Int, withQuery query: String? = nil) {
        // Either we have a query from the user's input or we need need to fetch the next page for the same query
        if let query = query ?? productsResponse?.query {
            service.getProducts(for: query, page: page) { response in
                // TODO If this query returns only a product, should it go directly to detail view instead of the tableview?
                if self.productsResponse == nil || self.productsResponse?.query != query { // Got new response
                    self.productsResponse = response
                    self.productsResponse!.query = query
                } else if self.productsResponse?.query == query, let newProducts = response.products { // Append new projects to existing response
                    self.productsResponse!.products!.append(contentsOf: newProducts)
                }
                
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Gesture recognizers

extension SearchTableViewController {
    func didTapTableViewBackground(_ sender: UITapGestureRecognizer) {
        
        // When the search bar has no text and the user taps the background view of the table view,
        // ask the search bar to resign focus so it goes back to it's begining state and the keyboard gets dismissed
        
        if productsResponse == nil && searchController.isActive {
            if let text = searchController.searchBar.text, text.isEmpty {
                searchController.searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Private functions
private extension SearchTableViewController {
    
    func showProductDetails(product: Product) {
        navigationController?.pushViewController(productDetails(product: product), animated: true)
    }
    
    func productDetails(product: Product) -> ProductDetailViewController {
        let storyboard = UIStoryboard(name: String(describing: ProductDetailViewController.self), bundle: nil)
        let productDetailVC = storyboard.instantiateInitialViewController() as! ProductDetailViewController
        productDetailVC.product = product
        return productDetailVC
    }
}

// MARK: - Scanning

extension SearchTableViewController {
    
    func scanBarcode() {
        navigationController?.pushViewController(ScannerViewController(), animated: true)
    }
}
