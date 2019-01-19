//
//  ProductsViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol CameraController {
    var delegate: CameraControllerDelegate? { get set }

    /// Show camera's controller view
    func show()
}

protocol CameraControllerDelegate: class {
    func didGetImage(image: UIImage)
}

class CameraControllerImpl: NSObject, CameraController {
    fileprivate let presentingViewController: UIViewController
    var picker: UIImagePickerController?
    lazy var cameraHelper: CameraHelperProtocol = CameraHelper()

    weak var delegate: CameraControllerDelegate?

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
    }

    func show() {
        guard let picker = cameraHelper.getImagePickerForTaking(.image) else { return }
        self.picker = picker
        picker.delegate = self
        self.presentingViewController.present(picker, animated: true, completion: nil)
    }
}

extension CameraControllerImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.didGetImage(image: image)
            dismiss()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss()
    }

    fileprivate func dismiss() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}
