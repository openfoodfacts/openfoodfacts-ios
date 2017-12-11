//
//  SingleLetterNutriscoreView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
enum Nutriscore: String {
    case a
    case b
    case c
    case d
    case e
}
// swiftlint:enable identifier_name

struct NutriscoreColors {
    let background: String
    let letter: String
}

// Nutriscore color constants
let nutriscoreColors: [Nutriscore: NutriscoreColors] = [
    .a: NutriscoreColors(background: "22712F", letter: "339966"),
    .b: NutriscoreColors(background: "7BB20F", letter: "99CC66"),
    .c: NutriscoreColors(background: "F8C10A", letter: "FFFF66"),
    .d: NutriscoreColors(background: "E06D07", letter: "CC9966"),
    .e: NutriscoreColors(background: "DE2610", letter: "FF9966")
]

class SingleLetterNutriscoreView: UIView {
    var nutriscore: Nutriscore! {
        didSet {
            configureView()
        }
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: SingleLetterNutriscoreView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let constantEdgeRadius = CGFloat(30.0) // Constant from NutriScoreLogo project
        let scale = self.frame.width / CGFloat(310.0) // Original width used as reference in calculations
        let cornerRadius = scale * constantEdgeRadius

        contentView.layer.cornerRadius = cornerRadius
    }

    private func configureView() {
        textLabel.text = nutriscore.rawValue.uppercased()
        guard let colors = nutriscoreColors[nutriscore] else { return }
        textLabel.textColor = UIColor(hex: colors.letter)
        contentView.backgroundColor = UIColor(hex: colors.background)
        textLabel.textColor = .white
    }
}
