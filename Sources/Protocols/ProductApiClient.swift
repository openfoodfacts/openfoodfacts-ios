//
//  ProductApiClient.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 13/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol ProductApiClient where Self: UIViewController {
    var productApi: ProductApi! { get set }
}
