//
//  ProductAttributeViewController.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 11/3/20.
//

import UIKit

class ProductAttributeViewController: UIViewController {
    var stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red//DEBUG
        stackView.isHidden = true

        view.addSubview(stackView)
        // constraints
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 8.0

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewWillAppear(_ animated: Bool) {
        //DEBUG
    }

    func configureSubviews(with attributeView: AttributeView) {
        stackView.removeAllViews()
        guard let attribute = attributeView.attribute else { return }
        stackView.addArrangedSubview(attributeView)
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)

        descriptionLabel.text = attribute.descriptionLong ?? attribute.descriptionShort ?? "empty description"
        stackView.addArrangedSubview(descriptionLabel)
        stackView.isHidden = false
        for subView in stackView.arrangedSubviews {
            subView.backgroundColor = .green//DEBUG
            subView.isHidden = false
        }

    }

    func totalHeight() -> CGFloat {
        var total: CGFloat = 0.0
        for view in stackView.arrangedSubviews {
            total += view.frame.height
        }
        return total
    }
}
