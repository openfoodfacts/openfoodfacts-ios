//
//  ManualBarcodeInputView.swift
//  OpenFoodFacts
//

import UIKit

protocol ManualBarcodeInputDelegate: class {
    func didStartEditing()
    func didEndEditing()
    func didTapSearch()
}

class ManualBarcodeInputView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!

    weak var delegate: ManualBarcodeInputDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ManualBarcodeInputView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override func awakeFromNib() {
        instructionsLabel.text = "product-scanner.barcode-notfound.manual-enter".localized
        confirmButton.setTitle("generic.search".localized, for: .normal)
    }

    @IBAction func editingDidBegin(_ sender: Any) {
        delegate?.didStartEditing()
    }

    @IBAction func editingDidEnd(_ sender: Any) {
        delegate?.didEndEditing()
    }

    @IBAction func didTapConfirm(_ sender: Any) {
        delegate?.didTapSearch()
    }

}
