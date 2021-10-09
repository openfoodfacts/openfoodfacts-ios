//
//  PickerViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 08/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol PickerViewDelegate: AnyObject {
    func didGetSelection(value: Pickable)
    func didDismiss()
}

protocol Pickable {
    var rowTitle: String { get }
}

class PickerViewController: UIViewController {
    private var data: [Pickable]
    private var defaultValue: Int?
    weak var delegate: PickerViewDelegate?

    init(data: [Pickable], defaultValue: Int? = nil, delegate: PickerViewDelegate? = nil) {
        self.data = data
        self.defaultValue = defaultValue
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let picker = UIPickerView()
        picker.autoresizingMask = .flexibleHeight
        picker.delegate = self
        picker.dataSource = self
        self.view = picker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let defaultValue = self.defaultValue else { return }
        guard let picker = self.view as? UIPickerView else { return }
        picker.selectRow(defaultValue, inComponent: 0, animated: true)
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].rowTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didGetSelection(value: data[row])
    }
}
