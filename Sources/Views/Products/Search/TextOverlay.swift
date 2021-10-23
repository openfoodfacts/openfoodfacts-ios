//
//  RectangleOverlay.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

@IBDesignable class TextOverlay: UIView {
    fileprivate lazy var textLabel = UILabel()

    init() {
        super.init(frame: .zero)
        configureView()
        configureTextLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureView() {
        // Note this should be the same in normal and dark mode
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)

        let views = ["textLabel": textLabel]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[textLabel]-10-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[textLabel]-5-|", options: [], metrics: nil, views: views))
    }

    fileprivate func configureTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .lightGray
        textLabel.numberOfLines = 3
    }

    func setText(_ text: String) {
        UIView.transition(with: textLabel, duration: 0.25, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.textLabel.text = text
            }, completion: nil)
        configureAccessibility()
    }
    
    private func configureAccessibility() {
        textLabel.accessibilityTraits.insert(.header)
    }
}
