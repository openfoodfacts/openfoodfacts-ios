//
//  InitialView.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 05/03/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class InitialView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingTitleLabel: UILabel!
    @IBOutlet weak var loadingSubtitleLabel: UILabel!
    @IBOutlet weak var loadingProgressView: UIProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: InitialView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
