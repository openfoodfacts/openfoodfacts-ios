//
//  Flash.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

private let flashOffImageName = "flash_off"
private let flashOnImageName = "flash_on"
// swiftlint:disable identifier_name
enum FlashStatus {
    case off
    case on
}
// swiftlint:enable identifier_name

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

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: flashButtonSize),
            self.heightAnchor.constraint(equalToConstant: flashButtonSize)])
    }

    fileprivate func configureFlashImageView() {
        flashImageView.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(named: flashOffImageName)! // Show always be an asset

        NSLayoutConstraint.activate([
            flashImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.bottomAnchor.constraint(equalTo: flashImageView.bottomAnchor, constant: 7),
            flashImageView.widthAnchor.constraint(equalToConstant: image.size.width),
            flashImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)])
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        state = .off
    }
}
