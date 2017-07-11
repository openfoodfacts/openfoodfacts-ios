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
enum FlashStatus {
    case off
    case on
}

@IBDesignable class FlashButton: UIView {
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
    
    fileprivate var rectangle = UIView()
    fileprivate var flashImageView = UIImageView()
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        rectangle.frame = frame
        rectangle.layer.cornerRadius = rectangle.frame.size.width / 2
        rectangle.layer.masksToBounds = true
        rectangle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let image = UIImage(named: flashOffImageName)! // Show always be an asset
        
        flashImageView.translatesAutoresizingMaskIntoConstraints = false
        
        var rectangleConstraints = [NSLayoutConstraint]()
        rectangleConstraints.append(NSLayoutConstraint(item: flashImageView, attribute: .top, relatedBy: .equal, toItem: rectangle, attribute: .top, multiplier: 1, constant: 8))
        rectangleConstraints.append(NSLayoutConstraint(item: rectangle, attribute: .bottom, relatedBy: .equal, toItem: flashImageView, attribute: .bottom, multiplier: 1, constant: 7))
        rectangleConstraints.append(NSLayoutConstraint(item: flashImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: image.size.width))
        rectangleConstraints.append(NSLayoutConstraint(item: flashImageView, attribute: .centerX, relatedBy: .equal, toItem: rectangle, attribute: .centerX, multiplier: 1, constant: 0))
        
        rectangle.addSubview(flashImageView)
        rectangle.addConstraints(rectangleConstraints)
        
        // Init
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rectangle)
        
        var sizeConstraints = [NSLayoutConstraint]()
        sizeConstraints.append(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        sizeConstraints.append(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        
        self.addConstraints(sizeConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        state = .off
    }
}
