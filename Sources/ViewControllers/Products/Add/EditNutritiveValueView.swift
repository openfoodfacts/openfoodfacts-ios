//
//  EditNutritiveValue.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

enum NutritiveUnits {
    case energy
    case units
    case allUnits
    case alcohol
    case none

    func unitsValues() -> [String] {
        switch self {
        case .energy:
            return [
                "kcal",
                "kJ"
            ]
        case .units:
            return [
                "g",
                "mg",
                "µg"
            ]
        case .allUnits:
            return [
                "g",
                "mg",
                "µg",
                "% DV",
                "IU"
            ]
        case .alcohol:
            return ["% vol / *"]
        case .none:
            return []
        }
    }
}

protocol EditNutritiveValueViewDelegate: class {
    func didChangeUnit(view: EditNutritiveValueView)
}

class EditNutritiveValueView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var singleUnitLabel: UILabel!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var hiddenUnitInputTextField: UITextField!
    @IBOutlet weak var tooMuchLabel: UILabel!

    weak var delegate: EditNutritiveValueViewDelegate?

    var nutrimentCode: String = ""
    var displayedUnit: NutritiveUnits = .units {
        didSet {
            if displayedUnit != oldValue {
                refreshButton()
            }
        }
    }
    var selectedUnit: String? {
        didSet {
            if selectedUnit != oldValue {
                refreshButton(selectedValue: selectedUnit)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: EditNutritiveValueView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tooMuchLabel.isHidden = true

        refreshButton()
    }

    fileprivate func refreshButton(selectedValue: String? = nil) {
        singleUnitLabel.isHidden = true
        unitButton.isHidden = true

        let values = displayedUnit.unitsValues()
        selectedUnit = selectedValue ?? values.first

        if values.count == 1 {
            singleUnitLabel.isHidden = false
            singleUnitLabel.text = values[0]
        } else if values.count > 1 {
            unitButton.setTitle(selectedUnit, for: .normal)
            unitButton.isHidden = false
        }
    }

    func getInputValue() -> Double? {
        if let txt = inputTextField.text?.replacingOccurrences(of: ",", with: ".") {
            return Double(txt)
        }
        return nil
    }

    func getSelectedUnit() -> String? {
        return selectedUnit
    }

    @IBAction func unitButtonTapped(_ sender: Any) {
        let values = displayedUnit.unitsValues()

        if values.count < 2 {
            // button should not be visible anyway ?
            return
        }

        var defaultValue: Int = 0
        if let selectedUnit = selectedUnit {
            defaultValue = values.firstIndex(of: selectedUnit) ?? 0
        }
        let picker = PickerViewController(data: values, defaultValue: defaultValue, delegate: self)
        let pickerToolbar = PickerToolbarViewController(title: titleLabel.text, delegate: self)

        if let pickerView = picker.view as? UIPickerView {
            self.hiddenUnitInputTextField.inputView = pickerView
        }
        if let toolbarView = pickerToolbar.view as? UIToolbar {
            self.hiddenUnitInputTextField.inputAccessoryView = toolbarView
        }
        self.hiddenUnitInputTextField.becomeFirstResponder()
    }
}

extension EditNutritiveValueView: PickerViewDelegate {
    func didGetSelection(value: Pickable) {
        self.selectedUnit = value.rowTitle
        self.refreshButton(selectedValue: self.selectedUnit)
        self.delegate?.didChangeUnit(view: self)
    }

    func didDismiss() {
        self.hiddenUnitInputTextField.resignFirstResponder()
    }
}
