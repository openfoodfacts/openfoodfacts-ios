//
//  SelectAllergenViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 24/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectAllergenDelegate: class {
    func didSelect(allergen: Allergen)
}

class SelectAllergenViewController: SelectTaxonomyViewController<Allergen> {

    weak var delegate: SelectAllergenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "select-allergen.title".localized
        searchBar.placeholder = "select-allergen.search-placeholder".localized
    }

    override func title(forItem allergen: Allergen) -> String {
        return allergen.names.chooseForCurrentLanguage(defaultToFirst: true)?.value ?? allergen.code
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let allergen = results?[indexPath.row] {
                delegate?.didSelect(allergen: allergen)
            }
        case 1:
            if let allergen = resultsWithEmptyNames?[indexPath.row] {
                delegate?.didSelect(allergen: allergen)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
