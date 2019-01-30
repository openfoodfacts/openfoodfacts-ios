//
//  NutriScoreView.swift
//  NutriScoreLogo
//
//  Created by arnaud on 24/03/17.
//  Copyright © 2017 Hovering Above. All rights reserved.
//

import UIKit

@IBDesignable class NutriScoreView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var imageView: UIImageView!

    // swiftlint:disable identifier_name
    public enum Score: String {
        case a
        case b
        case c
        case d
        case e
    }
    // swiftlint:enable identifier_name

    public var currentScore: Score? = nil {
        didSet {
            if let currentScore = currentScore {
                imageView.image = UIImage(named: "nutriscore-\(currentScore)")
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
        }
    }

    //
    // https://stackoverflow.com/questions/39816898/be-able-to-load-xib-from-both-storyboard-and-viewcontroller
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        view = loadViewFromNib()

        // use bounds not frame or it'll be offset
        view.frame = bounds

        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NutriScoreView", bundle: bundle)
        // swiftlint:disable:next force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}
