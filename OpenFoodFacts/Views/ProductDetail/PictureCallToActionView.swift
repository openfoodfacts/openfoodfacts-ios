//
//  PictureCallToActionView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 26/06/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

@IBDesignable class PictureCallToActionView: UIView {

    @IBOutlet weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    fileprivate func setupView() {
        let view = loadFromNib()
        view.frame = bounds

        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }

    fileprivate func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        // swiftlint:disable force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
    }
}
