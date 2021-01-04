//
//  EcoscoreImageView.swift
//  OpenFoodFacts
//
//  Created by arnaud on 21/11/2020.
//

import UIKit

class EcoscoreImageView: UIImageView {

    public enum Ecoscore: String {
        case ecoscoreA = "a"
        case ecoscoreB = "b"
        case ecoscoreC = "c"
        case ecoscoreD = "d"
        case ecoscoreE = "e"
        case unknown
    }

    /// return the currently displayed nova group
    public var ecoScore: Ecoscore = .unknown {
        didSet {
            self.image = UIImage(named: "ecoscore-\(ecoScore.rawValue)")
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
