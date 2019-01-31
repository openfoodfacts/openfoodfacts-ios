//
//  NovaScoreView.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 30/01/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NovaGroupView: UIImageView {

    public enum NovaGroup: String {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
    }

    /// return the currently displayed nova group
    var novaGroup: NovaGroup = .one {
        didSet {
            self.image = UIImage(named: "nova-group-\(novaGroup.rawValue)")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.contentMode = .scaleAspectFit
    }
}
