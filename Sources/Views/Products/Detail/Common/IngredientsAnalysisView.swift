//
//  IngredientsAnalysisView.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 22/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

@IBDesignable class IngredientsAnalysisView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    var title: String = ""
    var detail: IngredientsAnalysisDetail = IngredientsAnalysisDetail()

    func configure(detail: IngredientsAnalysisDetail) {
        self.backgroundColor = detail.color
        self.layer.cornerRadius = 5
        self.title = detail.title
        self.detail = detail
        guard let url = URL(string: detail.icon) else { return }
        iconImageView.kf.setImage(with: url)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
