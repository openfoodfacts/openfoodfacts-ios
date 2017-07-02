//
//  LoadingView.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/06/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class LoadingView: StateView {
    override func setupView() {
        super.setupView()
        
        self.frame = super.frame
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = super.center
        
        self.addSubview(activityIndicator)
    }
}
