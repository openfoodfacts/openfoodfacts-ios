//
//  IngredientsAnalysisView.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 22/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

@IBDesignable class IngredientsAnalysisView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!

    func configure(imageURL: String, color: UIColor) {
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        
        guard let url = URL(string: imageURL) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.iconImageView.image = image
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
