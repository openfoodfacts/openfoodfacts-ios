//
//  ProductAttributeViewController.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 11/3/20.
//

import UIKit

class ProductAttributeViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        stackView.backgroundColor = .white

        stackView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    func configureSubviews() {
        stackView.isHidden = false
         for subView in stackView.arrangedSubviews {
             subView.backgroundColor = .green
             subView.isHidden = false
         }
    }
}
