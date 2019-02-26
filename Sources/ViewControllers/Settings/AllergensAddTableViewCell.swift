//
//  AllergensAddTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 24/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol AllergensAddTableViewCellDelegate: class {
    func didTapAddButton()
}

class AllergensAddTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    weak var delegate: AllergensAddTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        addButton.titleLabel?.lineBreakMode = .byWordWrapping
        addButton.titleLabel?.numberOfLines = 2
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.didTapAddButton()
    }
}
