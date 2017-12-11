//
//  UITableViewTests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts

let rowNumber = 5

class UITableViewTest: XCTestCase {
    func testLastIndexPath() {
        let tableView = UITableView()
        tableView.dataSource = self

        let expected = IndexPath(row: rowNumber - 1, section: 0)
        XCTAssertEqual(expected, tableView.lastIndexPath)
    }
}

extension UITableViewTest: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
