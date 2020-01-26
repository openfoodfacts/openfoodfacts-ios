//
//  IngredientsAnalysisSettingsTableViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 26/01/2020.
//  Copyright © 2020 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RealmSwift

class IngredientsAnalysisSettingsTableViewController: UITableViewController {

    var allTypes: [String] = [String]()

    var dataManager: DataManagerProtocol!
    var allIngredientsAnalysisConfig: Results<IngredientsAnalysisConfig>!
    var observeToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "settings.ingredientsAnalysis.title".localized

        self.tableView.register(UINib(nibName: "IngredientsAnalysisSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientsAnalysisSettingsTableViewCellReuseIdentifier")

        allIngredientsAnalysisConfig = dataManager.objectSearch(forQuery: nil, ofClass: IngredientsAnalysisConfig.self)
        observeToken = allIngredientsAnalysisConfig.observe { [weak self] (changes) in
            switch changes {
            case .initial, .update:
                let newValues = self?.allIngredientsAnalysisConfig.compactMap({ (iac: IngredientsAnalysisConfig) -> String? in
                    return iac.type
                }).reduce([String](), { (result, elt) -> [String] in
                    if !result.contains(elt) {
                        return result + [elt]
                    }
                    return result
                })
                if let newValues = newValues {
                    self?.allTypes = newValues
                    self?.tableView.reloadData()
                }
            case .error(let error):
                log.error(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTypes.count
    }

    // swiftlint:disable force_cast
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsAnalysisSettingsTableViewCellReuseIdentifier", for: indexPath) as! IngredientsAnalysisSettingsTableViewCell

        let item = allTypes[indexPath.row]

        if let tags = self.dataManager.ingredientsAnalysis(forTag: "en:" + item) {
            let tag = Tag.choose(inTags: Array(tags.names))
            cell.configure(withType: item, andTranslatedName: tag?.value ?? item)
        } else {
            cell.configure(withType: item, andTranslatedName: item)
        }

        return cell
    }
    // swiftlint:enable force_cast
}
