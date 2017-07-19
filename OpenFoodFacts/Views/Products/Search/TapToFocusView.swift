//
//  TapToFocusView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

fileprivate let initialSideSize = 100
fileprivate let finalSideSize = 70
fileprivate let borderColor = UIColor(red: 1.00, green: 0.80, blue: 0.00, alpha: 1.0)

class TapToFocusView: UIView {
    fileprivate let initialSize = CGSize(width: initialSideSize, height: initialSideSize)
    fileprivate let finalSize = CGSize(width: finalSideSize, height: finalSideSize)
    fileprivate let initialColor = borderColor.cgColor
    fileprivate let finalColor = borderColor.withAlphaComponent(0.5).cgColor

    convenience init() {
        self.init(frame: .zero)
        self.frame.size = initialSize
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
    }

    func updateCenter(_ center: CGPoint) {
        self.frame.size = initialSize
        self.center = center
        self.layer.borderColor = initialColor

        UIView.animate(withDuration: 0.25, animations: {
            self.frame.size = self.finalSize
            self.center = center
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.layer.borderColor = self.finalColor
            })
        })
    }
}
