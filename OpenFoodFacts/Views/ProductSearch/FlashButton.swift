//
//  Flash.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

fileprivate let flashOffImageName = "flash_off"
fileprivate let flashOnImageName = "flash_on"
// swiftlint:disable identifier_name
enum FlashStatus {
    case off
    case on
}

@IBDesignable class FlashButton: UIView {
    @IBInspectable fileprivate var flashButtonSize: CGFloat = 40

    var state = FlashStatus.off {
        didSet {
            switch state {
            case .off:
                flashImageView.image = UIImage(named: flashOffImageName)
            case .on:
                flashImageView.image = UIImage(named: flashOnImageName)
            }
        }
    }

    fileprivate var flashImageView = UIImageView()

    init() {
        super.init(frame: .zero)
        configureView()
        configureFlashImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = flashButtonSize / 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(flashImageView)

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: flashButtonSize))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: flashButtonSize))
    }

    fileprivate func configureFlashImageView() {
        flashImageView.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(named: flashOffImageName)! // Show always be an asset

        self.addConstraint(NSLayoutConstraint(item: flashImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: flashImageView, attribute: .bottom, multiplier: 1, constant: 7))
        self.addConstraint(NSLayoutConstraint(item: flashImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: image.size.width))
        self.addConstraint(NSLayoutConstraint(item: flashImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        state = .off
    }
}
