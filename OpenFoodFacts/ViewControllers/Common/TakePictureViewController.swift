//
//  TakePictureViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 29/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import NotificationBanner

class TakePictureViewController: UIViewController {
    var productApi: ProductApi!
    var barcode: String!
    var imageType: ImageType = .front
    var cameraController: CameraController?

    // Feedback banners
    lazy var uploadingImageBanner: StatusBarNotificationBanner = {
        let banner = StatusBarNotificationBanner(title: NSLocalizedString("product-add.uploading-image-banner.title", comment: ""), style: .info)
        banner.autoDismiss = false
        return banner
    }()
    lazy var uploadingImageErrorBanner: NotificationBanner = {
        let banner = NotificationBanner(title: NSLocalizedString("product-add.image-upload-error-banner.title", comment: ""),
                                        subtitle: NSLocalizedString("product-add.image-upload-error-banner.subtitle", comment: ""),
                                        style: .danger)
        return banner
    }()
    lazy var uploadingImageSuccessBanner: NotificationBanner = {
        let banner = NotificationBanner(title: NSLocalizedString("product-add.image-upload-success-banner.title", comment: ""), style: .success)
        return banner
    }()
    lazy var productAddSuccessBanner: NotificationBanner = {
        let banner = NotificationBanner(title: NSLocalizedString("product-add.product-add-success-banner.title", comment: ""), style: .success)
        return banner
    }()

    @IBAction func didTapTakePictureButton(_ sender: Any) {
        if self.cameraController == nil {
            self.cameraController = CameraControllerImpl(presentingViewController: self)
        }
        guard var cameraController = self.cameraController else { return }
        cameraController.delegate = self
        cameraController.show()
    }
}

extension TakePictureViewController: CameraControllerDelegate {
    func didGetImage(image: UIImage) {
        // For now, images will be always uploaded with type front
        uploadingImageBanner.show()
        productApi.postImage(ProductImage(image: image, type: imageType), barcode: barcode, onSuccess: {
            self.uploadingImageBanner.dismiss()
            self.uploadingImageSuccessBanner.show()
            self.postImageSuccess()
        }, onError: { _ in
            self.uploadingImageBanner.dismiss()
            self.uploadingImageErrorBanner.show()
        })
    }

    @objc func postImageSuccess() { /* Do nothing, overridable */ }
}
