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
    @IBOutlet weak var taglineButton: UIButton!

    var tagline: Tagline? {
        didSet {
            refreshTaglineButton()
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
        Bundle.main.loadNibNamed(String(describing: InitialView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        taglineButton.titleLabel?.numberOfLines = 0
        taglineButton.titleLabel?.textAlignment = .center
        taglineButton.isHidden = true
    }

    fileprivate func refreshTaglineButton() {
        if let tagline = tagline {
            self.taglineButton.setTitle(tagline.message, for: .normal)
            self.taglineButton.isHidden = false
        } else {
            self.taglineButton.isHidden = true
        }
    }

    @IBAction func onTaglineButtonTapped() {
        if let tagline = tagline, let url = URL(string: tagline.url) {
            self.viewController()?.openUrlInApp(url)
        }
    }
}
