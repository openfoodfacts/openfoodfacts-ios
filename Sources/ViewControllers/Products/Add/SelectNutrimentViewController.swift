//
//  SelectProductCategoryTableViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 08/02/2019.
//

import UIKit
import RealmSwift

protocol SelectNutrimentDelegate: class {
    func didSelect(nutriment: Nutriment)
}

class SelectNutrimentViewController: SelectTaxonomyViewController<Nutriment> {

    weak var delegate: SelectNutrimentDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "select-nutriment.title".localized
        searchBar.placeholder = "select-nutriment.search-placeholder".localized
    }

    override func title(forItem nutriment: Nutriment) -> String {
        return nutriment.names.chooseForCurrentLanguage(defaultToFirst: true)?.value ?? nutriment.code
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let nutriment = results?[indexPath.row] {
                delegate?.didSelect(nutriment: nutriment)
            }
        case 1:
            if let nutriment = resultsWithEmptyNames?[indexPath.row] {
                delegate?.didSelect(nutriment: nutriment)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
