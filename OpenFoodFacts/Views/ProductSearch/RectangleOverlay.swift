//
//  RectangleOverlay.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

@IBDesignable class RectangleOverlay: UIView {
    fileprivate lazy var textLabel = UILabel()
    var text = String() {
        didSet {
            textLabel.text = text
        }
    }
    
    convenience init() {
        self.init(text: "")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        configureView()
        configureTextLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
        
        let views = ["textLabel": textLabel]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[textLabel]-10-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[textLabel]-5-|", options: [], metrics: nil, views: views)
        
        self.addConstraints(constraints)
    }
    
    fileprivate func configureTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .white
    }
}
