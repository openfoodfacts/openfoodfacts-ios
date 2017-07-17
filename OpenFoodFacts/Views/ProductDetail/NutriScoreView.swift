//
//  NutriScoreView.swift
//  NutriScoreLogo
//
//  Created by arnaud on 24/03/17.
//  Copyright © 2017 Hovering Above. All rights reserved.
//

import UIKit

@IBDesignable class NutriScoreView: UIView {

    private struct Constant {
        static let CornerRadius = CGFloat(30.0)
        static let BorderWidth = CGFloat(6.0)
        static let BorderColor = UIColor.white.cgColor
        static let StandardWidth = CGFloat(310.0)
        static let StandardFontSize = CGFloat(60.0)
        // static let SelectedWidth = CGFloat(78.0)
        static let SelectedFontSize = CGFloat(80.0)
        static let EdgeRadius = CGFloat(30.0)
    }

    private var scale: CGFloat {
        return self.frame.size.width / Constant.StandardWidth
    }

    @IBOutlet var view: UIView!

    @IBOutlet weak var AView: UIView!

    @IBOutlet weak var ACornerView: UIView!

    @IBOutlet weak var ALabel: UILabel!

    @IBOutlet weak var BView: UIView!

    @IBOutlet weak var BLabel: UILabel!

    @IBOutlet weak var CView: UIView!

    @IBOutlet weak var CLabel: UILabel!

    @IBOutlet weak var DView: UIView!

    @IBOutlet weak var DLabel: UILabel!

    @IBOutlet weak var EView: UIView!

    @IBOutlet weak var ELabel: UILabel!

    @IBOutlet weak var ASelectedLabel: UILabel!

    @IBOutlet weak var ASuperView: UIView! {
        didSet {
            ASuperView?.isHidden = currentScore == .A ? false : true
            ASuperView?.layer.borderColor = Constant.BorderColor
        }
    }

    @IBOutlet weak var BSuperView: UIView! {
        didSet {
            BSuperView?.isHidden = currentScore == .B ? false : true
            BSuperView?.layer.borderColor = Constant.BorderColor
        }
    }

    @IBOutlet weak var BSelectedLabel: UILabel!

    @IBOutlet weak var CSuperView: UIView! {
        didSet {
            CSuperView?.isHidden = currentScore == .C ? false : true
            CSuperView?.layer.borderColor = Constant.BorderColor
        }
    }

    @IBOutlet weak var CSelectedLabel: UILabel!

    @IBOutlet weak var DSuperView: UIView! {
        didSet {
            DSuperView?.isHidden = currentScore == .D ? false : true
            DSuperView?.layer.borderColor = Constant.BorderColor
        }
    }

    @IBOutlet weak var DSelectedLabel: UILabel!

    @IBOutlet weak var ESuperView: UIView! {
        didSet {
            ESuperView?.isHidden = currentScore == .E ? false : true
            ESuperView?.layer.borderColor = Constant.BorderColor
        }
    }

    @IBOutlet weak var ESelectedLabel: UILabel!

    // swiftlint:disable identifier_name
    public enum Score: String {
        case A
        case B
        case C
        case D
        case E
    }

    public var currentScore: Score? = nil {
        didSet {
            ASuperView?.isHidden = currentScore == .A ? false : true
            BSuperView?.isHidden = currentScore == .B ? false : true
            CSuperView?.isHidden = currentScore == .C ? false : true
            DSuperView?.isHidden = currentScore == .D ? false : true
            ESuperView?.isHidden = currentScore == .E ? false : true

            setupViews()
        }
    }

    private func setupViews() {

        ALabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.StandardFontSize)
        BLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.StandardFontSize)
        CLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.StandardFontSize)
        DLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.StandardFontSize)
        ELabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.StandardFontSize)

        AView?.layer.cornerRadius = scale * Constant.EdgeRadius
        EView?.layer.cornerRadius = scale * Constant.EdgeRadius

        ASuperView?.layer.cornerRadius = scale * Constant.CornerRadius
        ASuperView?.layer.borderWidth = scale * Constant.BorderWidth
        ASelectedLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.SelectedFontSize)

        BSuperView?.layer.cornerRadius = scale * Constant.CornerRadius
        BSuperView?.layer.borderWidth = scale * Constant.BorderWidth
        BSelectedLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.SelectedFontSize)

        CSuperView?.layer.cornerRadius = scale * Constant.CornerRadius
        CSuperView?.layer.borderWidth = scale * Constant.BorderWidth
        CSelectedLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.SelectedFontSize)

        DSuperView?.layer.cornerRadius = scale * Constant.CornerRadius
        DSuperView?.layer.borderWidth = scale * Constant.BorderWidth
        DSelectedLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.SelectedFontSize)

        ESuperView?.layer.cornerRadius = scale * Constant.CornerRadius
        ESuperView?.layer.borderWidth = scale * Constant.BorderWidth
        ESelectedLabel.font = UIFont.boldSystemFont(ofSize: scale * Constant.SelectedFontSize)

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
        // swiftlint:disable force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
}
