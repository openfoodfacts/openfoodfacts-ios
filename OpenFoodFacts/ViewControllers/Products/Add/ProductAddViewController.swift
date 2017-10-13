//
//  ProductAddViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import NotificationBanner

class ProductAddViewController: TakePictureViewController {
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var productNameField: UITextField!
    @IBOutlet weak var brandsField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadedImagesStackView: UIStackView!

    var activeField: UITextField?
    var contentInsetsBeforeKeyboard = UIEdgeInsets.zero
    lazy var product = Product()
    lazy var productPostErrorAlert: UIAlertController = {
        let alert = UIAlertController(title: NSLocalizedString("product-add.save-error.title", comment: ""),
                                      message: NSLocalizedString("product-add.save-error.message", comment: ""),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("product-add.save-error.action", comment: ""),
                                      style: .default,
                                      handler: { _ in alert.dismiss(animated: true, completion: nil) }))
        return alert
    }()

    override var barcode: String! {
        didSet {
            product.barcode = barcode
        }
    }

    override func viewDidLoad() {
        productNameField.delegate = self
        brandsField.delegate = self
        quantityField.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barcodeLabel.text = barcode
    }

    @IBAction func didTapSaveButton(_ sender: UIButton) {
        activeField?.resignFirstResponder()
        product.name = productNameField.text
        if let brand = brandsField.text {
            product.brands = [brand]
        }
        product.quantity = quantityField.text

        productApi.postProduct(product, onSuccess: {
            self.productAddSuccessBanner.show()
            self.navigationController?.popToRootViewController(animated: true)
        }, onError: { _ in
            self.present(self.productPostErrorAlert, animated: true, completion: nil)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TakePictureSegue" {
            guard let destination = segue.destination as? PictureTableViewController else { return; }
            destination.barcode = barcode
            destination.productApi = productApi
        }
    }
}

// MARK: - Keyboard notification handler
extension ProductAddViewController {
    @objc func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo
        guard let keyboardFrame = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let activeField = self.activeField else { return }

        let keyboardHeight: CGFloat = keyboardFrame.height < keyboardFrame.width ? keyboardFrame.height : keyboardFrame.width

        self.contentInsetsBeforeKeyboard = scrollView.contentInset
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = keyboardHeight
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        // If field is hidden by keyboard, scroll so it's visible
        var frame = self.view.frame
        frame.size.height -= keyboardHeight
        if !frame.contains(activeField.frame.origin) {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = self.contentInsetsBeforeKeyboard
        scrollView.scrollIndicatorInsets = self.contentInsetsBeforeKeyboard
    }
}

extension ProductAddViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
