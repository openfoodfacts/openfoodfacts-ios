//
//  AllergensAlertsTableViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 24/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RealmSwift

class AllergensAlertsTableViewController: UITableViewController {

    fileprivate static let AllergenCellIdentifier = "ALLERGEN_CELL_IDENTIFIER"

    var dataManager: DataManagerProtocol!
    var allergies: Results<Allergen>!
    var observeToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "settings.allergies.title".localized

        self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: AllergensAlertsTableViewController.AllergenCellIdentifier)
        self.tableView.register(UINib(nibName: "AllergensAddTableViewCell", bundle: nil), forCellReuseIdentifier: "AllergensAddTableViewCellReuseIdentifier")

        allergies = dataManager.listAllergies()
        observeToken = allergies.observe { [weak self] (changes) in
            switch changes {
            case .initial: self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map { IndexPath(item: $0, section: 0) }, with: .top)
                self?.tableView.deleteRows(at: deletions.map { IndexPath(item: $0, section: 0) }, with: .fade)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView?.endUpdates()
            case .error(let error):
                log.error(error)
            }
        }

    }

    deinit {
        observeToken?.invalidate()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return allergies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllergensAddTableViewCellReuseIdentifier", for: indexPath) as! AllergensAddTableViewCell
            cell.delegate = self
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: AllergensAlertsTableViewController.AllergenCellIdentifier, for: indexPath)

        let allergy = allergies[indexPath.row]
        cell.textLabel?.text = allergy.names.chooseForCurrentLanguage()?.value

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.section == 0
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 0: return .delete
        default: return .none
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let allergy = allergies[indexPath.row]
            dataManager.removeAllergy(toAllergen: allergy)
        } else if editingStyle == .insert {
            self.didTapAddButton()
        }
    }
}


extension AllergensAlertsTableViewController: AllergensAddTableViewCellDelegate {
    func didTapAddButton() {
        let searchAllergenVC = SelectAllergenViewController(nibName: "SelectAllergenViewController", bundle: nil)
        searchAllergenVC.dataManager = self.dataManager
        searchAllergenVC.delegate = self
        self.navigationController?.pushViewController(searchAllergenVC, animated: true)
    }
}

extension AllergensAlertsTableViewController: SelectAllergenDelegate {
    func didSelect(allergen: Allergen) {
        dataManager.addAllergy(toAllergen: allergen)
        self.navigationController?.popToViewController(self, animated: true)
    }
}
