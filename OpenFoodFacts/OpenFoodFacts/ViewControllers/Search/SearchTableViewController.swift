//
//  SearchTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    var products = [Product(name: "Coca Cola Light", brand: "Coca Cola", quantity: "33 ml"),
                    Product(name: "Coca Cola", brand: "Coca Cola", quantity: "33 ml"),
                    Product(name: "Fanta", brand: "Fanta", quantity: "33 ml"),
                    Product(name: "7UP", brand: "Coca Cola", quantity: "33 ml")]
    var filteredProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSearchController()
    }
    
    fileprivate func configureTableView() {
        tableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
    }
    
    fileprivate func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension SearchTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredProducts.count
        }
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        
        let product = searchController.isActive && searchController.searchBar.text != "" ? filteredProducts[indexPath.row] : products[indexPath.row]
        cell.configure(withProduct: product)
        
        return cell
    }
}

extension SearchTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmpty {
            filteredProducts = products.filter { product in return product.name.contains(query) }
        } else {
            
        }
        
        tableView.reloadData()
    }
}
