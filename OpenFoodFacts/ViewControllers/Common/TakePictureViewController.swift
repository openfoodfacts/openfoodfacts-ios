//
//  TakePictureViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 29/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import NotificationBanner

protocol TakePictureViewControllerDelegate: class {
    func postImageSuccess()
}

class TakePictureViewController: UIViewController {
    var productService: ProductService!
    var barcode: String!
    fileprivate var cameraController: CameraController?
    weak var delegate: TakePictureViewControllerDelegate?

    // Feedback banners
    fileprivate lazy var uploadingImageBanner: StatusBarNotificationBanner = {
        let banner = StatusBarNotificationBanner(title: NSLocalizedString("product-add.uploading-image-banner.title", comment: ""), style: .info)
        banner.autoDismiss = false
        return banner
    }()
    fileprivate lazy var uploadingImageErrorBanner: NotificationBanner = {
        let banner = NotificationBanner(title: NSLocalizedString("product-add.image-upload-error-banner.title", comment: ""),
                                        subtitle: NSLocalizedString("product-add.image-upload-error-banner.subtitle", comment: ""),
                                        style: .danger)
        return banner
    }()
    fileprivate lazy var uploadingImageSuccessBanner: NotificationBanner = {
        let banner = NotificationBanner(title: NSLocalizedString("product-add.image-upload-success-banner.title", comment: ""), style: .success)
        return banner
    }()
    fileprivate lazy var productAddSuccessBanner: NotificationBanner = {
        let banner = NotificationBanner(title: NSLocalizedString("product-add.product-add-success-banner.title", comment: ""), style: .success)
        return banner
    }()

    @IBAction func didTapTakePictureButton(_ sender: UIButton) {
        if let cameraController = CameraController(presentingViewController: self) {
            self.cameraController = cameraController
            cameraController.delegate = self
            cameraController.show()
        }
    }
}

extension TakePictureViewController: CameraControllerDelegate {
    func didGetImage(image: UIImage) {
        // For now, images will be always uploaded with type front
        uploadingImageBanner.show()
        productService.postImage(ProductImage(image: image, type: .front), barcode: barcode, onSuccess: {
            self.uploadingImageBanner.dismiss()
            self.uploadingImageSuccessBanner.show()
            self.delegate?.postImageSuccess()
        }, onError: { _ in
            self.uploadingImageBanner.dismiss()
            self.uploadingImageErrorBanner.show()
        })
    }
}
