//
//  CreditsViewController.swift
//  OpenFoodFacts
//
//  Created by Егор on 2/16/18.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import UIKit

class CreditsViewController: UIViewController {

    private var tableView: UITableView!

    private let contributors = ContributorsFactory.getContributors()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0.0),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0.0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0.0)
        ])
        view.layoutIfNeeded()
    }

}

extension CreditsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contributer = contributors[indexPath.row]
        cell.textLabel?.attributedText = contributer.attributedText
        cell.textLabel?.numberOfLines = 0
        if contributer.urlString != nil {
            cell.accessoryType = .detailButton
        }
        return cell
    }

}

extension CreditsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let contributer = contributors[indexPath.row]
        if let url = URL(string: contributer.urlString ?? "") {
            openUrlInApp(url)
        }
    }
}

struct ContributorsFactory {
    static func getContributors() -> [Contributor] {
        return [
            Contributor(mainText: "\"Barcode scan\" button icon, \"Settings\" icon and \"Flash\" icon made by ",
                        name: "Madebyoliver",
                        urlString: nil),
            Contributor(mainText: "\"Take picture\" icon made by ",
                        name: "Picol",
                        urlString: nil),
            Contributor(mainText: "\"Profile\" icon, \"Gregor Cresnar\" icon, and \"Search history\" icon made by ",
                        name: "Smashicons",
                        urlString: "http://www.flaticon.com/authors/smashicons")
        ]
    }
    struct Contributor {
        private static let licensedBy = " is licensed by CC 3.0 BY"

        let mainText: String
        let name: String
        let urlString: String?

        var attributedText: NSAttributedString {
            let main = NSAttributedString(string: mainText)
            let licensedBy = NSAttributedString(string: Contributor.licensedBy)

            if urlString == nil {
                let nameString = NSAttributedString(string: name)
                return main + nameString + licensedBy
            } else {
                let hyperlink = NSAttributedString(string: name, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
                return main + hyperlink + licensedBy
            }
        }
    }
}
