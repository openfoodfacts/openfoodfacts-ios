//
//  ProductAttributeViewController.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 11/3/20.
//

import UIKit
import FloatingPanel

class ProductAttributeViewController: UIViewController {
    var stackView = UIStackView()
    var attributeView: AttributeView?
    var descriptionLabel: UILabel!
    var totalStackViewHeight: CGFloat = 0.0

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let newHeight = getTotalHeight()
        if newHeight != totalStackViewHeight, let floatingPanelVC = parent as? FloatingPanelController {
            totalStackViewHeight = newHeight
            floatingPanelVC.updateLayout()
        }
    }

    func configureSubviews() {
        resetView()
        guard let attributeView = attributeView,
              let attribute = attributeView.attribute else { return }
        stackView.addArrangedSubview(attributeView)
        descriptionLabel = UILabel()
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

    func resetView() {
        stackView.removeAllViews()
    }

    private func getTotalHeight() -> CGFloat {
        var total: CGFloat = 0.0
        for view in stackView.arrangedSubviews {
            total += view.frame.height
        }
        return total
    }
}
