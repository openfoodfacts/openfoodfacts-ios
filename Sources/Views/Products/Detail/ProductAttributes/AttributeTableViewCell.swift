//
//  AttributeTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on on 17/10/2020.
//  Copyright © 2020 Alexander Scott Beaty. All rights reserved.
//

import UIKit
import Kingfisher
import Cartography

protocol AttributeTableViewCellDelegate: class {
    func attributeTableViewCellTapped(_ sender: AttributeTableViewCell, _ attributeView: AttributeView)
}

class AttributeTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var stackView: UIStackView!

    public weak var delegate: AttributeTableViewCellDelegate?
    var attribute: Attribute?

    fileprivate var gestureRecognizer: UITapGestureRecognizer?

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let attributeTableRow = formRow.value as? AttributeTableRow,
              let attribute = attributeTableRow.attribute
        else { return }

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

        delegate = attributeTableRow.delegate
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
        guard let attribute = attribute else {
            return
        }

        let attributeView = AttributeView.loadFromNib()
        attributeView.configure(attribute)

        delegate?.attributeTableViewCellTapped(self, attributeView)
    }
}
