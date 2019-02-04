//
//  SelectProductCategoryTableViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 08/02/2019.
//

import UIKit
import RealmSwift

protocol SelectCategoryDelegate: class {
    func didSelect(category: Category)
    func didSelect(customCategory: String)
}

class SelectCategoryViewController: SelectTaxonomyViewController<Category> {

    weak var delegate: SelectCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.allowCustomEntry = true
        self.title = "select-category.title".localized
        searchBar.placeholder = "select-category.search-placeholder".localized
    }

    override func title(forItem category: Category) -> String {
        return category.names.chooseForCurrentLanguage(defaultToFirst: true)?.value ?? category.code
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let category = results?[indexPath.row] {
                delegate?.didSelect(category: category)
            }
        case 1:
            if let category = resultsWithEmptyNames?[indexPath.row] {
                delegate?.didSelect(category: category)
            }
        case 2:
            if let text = searchBar.text {
                delegate?.didSelect(customCategory: text)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
