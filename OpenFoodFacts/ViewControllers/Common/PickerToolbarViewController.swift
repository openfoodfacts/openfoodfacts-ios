//
//  PickerToolbarViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 08/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class PickerToolbarViewController: UIViewController {
    private let toolbarTitle: String
    private weak var delegate: PickerViewDelegate?

    init(title: String, delegate: PickerViewDelegate? = nil) {
        self.toolbarTitle = title
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                         action: #selector(PickerToolbarViewController.dismissPicker))

        let titleLabel = UILabel()
        titleLabel.text = toolbarTitle
        titleLabel.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
        let title = UIBarButtonItem(customView: titleLabel)

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isUserInteractionEnabled = true
        toolbar.setItems([space, title, space, doneButton], animated: false)

        self.view = toolbar
    }

    @objc func dismissPicker() {
        delegate?.didDismiss()
    }
}
