//
//  TakePictureButtonView.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 27/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol IconButtonViewDelegate: AnyObject {
    func didTap()
}

class IconButtonView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: IconButtonViewDelegate?

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

        let uselessButton = UIButton()

        iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = uselessButton.tintColor
        titleLabel.textColor = uselessButton.tintColor

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    fileprivate func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        // swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
    }

    @objc func didTap() {
        delegate?.didTap()
    }
}
