//
//  ProductsViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MobileCoreServices
import TOCropViewController

protocol CameraController {
    var delegate: CameraControllerDelegate? { get set }
    var imageType: ImageType? { get set }

    /// Show camera's controller view
    func show()
}

protocol CameraControllerDelegate: class {
    func didGetImage(image: UIImage, forImageType imageType: ImageType?)
}

class CameraControllerImpl: NSObject, CameraController {
    fileprivate let presentingViewController: UIViewController
    var picker: UIImagePickerController?
    lazy var cameraHelper: CameraHelperProtocol = CameraHelper()
    var imageType: ImageType?

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
            if imageType == .ingredients {
                dismiss()
                let cropViewController = TOCropViewController(image: image)
                cropViewController.delegate = self
                self.presentingViewController.present(cropViewController, animated: true, completion: nil)
            } else {
                delegate?.didGetImage(image: image, forImageType: imageType)
                dismiss()
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss()
    }

    fileprivate func dismiss() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}

extension CameraControllerImpl: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        delegate?.didGetImage(image: image, forImageType: imageType)
        dismiss()
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        dismiss()
    }
}
