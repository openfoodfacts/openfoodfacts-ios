//
//  ProductsViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol CameraControllerDelegate: class {
    func didGetImage(image: UIImage)
}

class CameraController: NSObject {
    fileprivate let presentingViewController: UIViewController
    fileprivate let desiredType: String
    fileprivate lazy var picker = UIImagePickerController()

    weak var delegate: CameraControllerDelegate?

    init?(presentingViewController: UIViewController) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return nil
        }

        let desiredType = String(kUTTypeImage)

        if UIImagePickerController.availableMediaTypes(for: .camera)?.index(of: desiredType) == nil {
            return nil
        }

        self.desiredType = desiredType
        self.presentingViewController = presentingViewController
    }

    func show() {
        picker.sourceType = .camera
        picker.mediaTypes = [desiredType]
        picker.delegate = self
        self.presentingViewController.present(picker, animated: true, completion: nil)
    }
}

extension CameraController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.didGetImage(image: image)
            dismiss()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss()
    }

    fileprivate func dismiss() {
        self.picker.dismiss(animated: true, completion: nil)
    }
}
