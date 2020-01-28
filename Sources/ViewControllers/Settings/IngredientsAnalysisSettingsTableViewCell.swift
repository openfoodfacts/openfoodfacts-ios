//
//  IngredientsAnalysisSettingsTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 26/01/2020.
//  Copyright © 2020 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class IngredientsAnalysisSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    var detailType: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingsSwitch.addTarget(self, action: #selector(changeSwitch(sender:)), for: .valueChanged)
    }

    func configure(withType: String, andTranslatedName: String) {
        self.detailType = withType
        self.settingsTitleLabel.text = String(format: "ingredients-analysis.display".localized, andTranslatedName)
        self.settingsSwitch.setOn(!UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayIngredientAnalysisStatus(withType)), animated: false)
    }

    @objc func changeSwitch(sender: UISwitch) {
        if let detailType = detailType {
            UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayIngredientAnalysisStatus(detailType))
        }
    }
}
