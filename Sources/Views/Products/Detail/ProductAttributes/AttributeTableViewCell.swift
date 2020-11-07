//
//  AttributeTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on on 17/10/2020.
//  Copyright © 2020 Alexander Scott Beaty. All rights reserved.
//

import UIKit
import BLTNBoard
import Kingfisher
import Cartography

protocol AttributeTableViewCellDelegate: class {
    func attributeTableViewCellDelegate(_ sender: AttributeTableViewCell, receivedTapOn view: UIView)
}

class AttributeTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var stackView: UIStackView!


    var attribute: Attribute?
    var showFloatingPanelHandler: ((AttributeView) -> Void)?

    fileprivate var gestureRecognizer: UITapGestureRecognizer?
    var bulletinManager: BLTNItemManager!

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let attribute = formRow.value as? Attribute else { return }
        self.attribute = attribute

        removeGestureRecognizer()
        // 'circle "i"' infoImage is in xib, need to retrieve it and add it back later
        let infoImageView = stackView.arrangedSubviews.last
        stackView.removeAllViews()

        let attributeView = AttributeView.loadFromNib()
        attributeView.configure(attribute)

        configureGestureRecognizer()
        stackView.addArrangedSubview(attributeView)
        if let iiv = infoImageView {
            stackView.addArrangedSubview(iiv)
        }

        // configure floating panel for the ProductAttribute rows
        formViewController?.configureFloatingPanel(attributeView)
        formViewController?.floatingPanelController.move(to: .hidden, animated: false)
        showFloatingPanelHandler = { [weak self] attributeView in
            self?.formViewController?.floatingPanelController.move(to: .full, animated: true)
        }
    }

    override func dismiss() {
        super.dismiss()
        stackView.arrangedSubviews.forEach {
            if let view = $0 as? IngredientsAnalysisView {
                view.removeGestureRecognizer()
            }
        }
        stackView.removeAllViews()
    }

    func configureGestureRecognizer() {
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        if let gestureRecognizer = self.gestureRecognizer {
            self.addGestureRecognizer(gestureRecognizer)
            self.isUserInteractionEnabled = true
        }
    }

    func removeGestureRecognizer() {
        if let validGesture = self.gestureRecognizer {
            self.removeGestureRecognizer(validGesture)
            self.gestureRecognizer = nil
        }
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        print("Attribute tapped")
        guard let attribute = attribute else {
            return
        }

        let attributeView = AttributeView.loadFromNib()
        attributeView.configure(attribute)

        showFloatingPanelHandler?(attributeView)
    }
}

class AttributeBLTNPageItem: BLTNPageItem {
    var attribute: Attribute?
    var iconImageBackgroundColor: UIColor?
    var attributeView: AttributeView?

    override func makeHeaderViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let containerA = UIView()
        containerA.backgroundColor = iconImageBackgroundColor

        if let attributeV = attributeView {
            containerA.addSubview(attributeV)

            constrain(attributeV, containerA) { (attributeV, containerA) in
                containerA.width == attributeV.width
                containerA.height == attributeV.height
                attributeV.edges == containerA.edges

            }

            var views: [UIView] = [containerA]

            if let attribute = attribute {
                let descriptionLabel = UILabel()
                descriptionLabel.numberOfLines = 0
                descriptionLabel.textAlignment = .center
                descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)

                descriptionLabel.text = attribute.descriptionLong ?? attribute.descriptionShort ?? "empty description"
                views.append(descriptionLabel)
            }
            return views
        }
        return nil
    }
}
