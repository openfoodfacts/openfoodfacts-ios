//
//  SearchTableViewControllerState.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/06/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

extension SearchTableViewController {

    /// State enum for the Search VC
    ///
    /// - initial: First stage after loading view
    /// - loading: Fetching results state
    /// - empty: No results
    /// - content: Displaying results
    /// - error: Error while fetching results
    enum State {
        case initial
        case loading
        case empty
        case content(ProductsResponse)
        case error(Error)
    }
}
