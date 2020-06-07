//
//  PictureTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol PictureTableViewControllerDelegate: class {
    func didPostIngredientImage()
}

class PictureTableViewController: TakePictureViewController {
    @IBOutlet weak var tableView: UITableView!
    var pictures = [PictureViewModel]()
    weak var delegate: PictureTableViewControllerDelegate?
    var productToEdit: Product?

    override func viewDidLoad() {
        tableView.isScrollEnabled = false
        pictures = [PictureViewModel]()
        pictures.append(PictureViewModel(imageType: .front))
        pictures.append(PictureViewModel(imageType: .ingredients))
        pictures.append(PictureViewModel(imageType: .nutrition))

        if let product = self.productToEdit {
            fillForm(withProduct: product)
            languageCode = productToEdit?.lang ?? "qq"
        }
        if let barcode = self.barcode, let pendingUploadItem = dataManager.getItemPendingUpload(forBarcode: barcode) {
            fillForm(withPendingUploadItem: pendingUploadItem)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.imageUploadProgress(_:)), name: .imageUploadProgress, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: .imageUploadProgress, object: nil)
    }

    @objc func imageUploadProgress(_ notification: NSNotification) {
        guard let validBarcode = productToEdit?.barcode else { return }
        guard let barcode = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadBarcodeString] as? String else { return }
        guard validBarcode == barcode else { return }
        // guard let languageCode = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadLanguageString] as? String else { return }
        guard let progress = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadFractionDouble] as? Double else { return }
        guard let imageTypeRaw = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadTypeString] as? String else { return }
        let imageType = ImageType(imageTypeRaw)
        showUploadingImage(forType: imageType, progress: progress)

    }

    fileprivate func index(forImageType type: ImageType) -> Int? {
        return pictures.firstIndex(where: { (pic: PictureViewModel) -> Bool in
            return pic.imageType == type
        })
    }

    fileprivate func fillForm(withProduct product: Product) {
        if let image = product.frontImageSmallUrl ?? product.frontImageUrl {
            if let index = index(forImageType: .front) {
                pictures[index].imageUrl = image
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        if let image = product.ingredientsImageUrl {
            if let index = index(forImageType: .ingredients) {
                pictures[index].imageUrl = image
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        if let image = product.nutritionTableImage {
            if let index = index(forImageType: .nutrition) {
                pictures[index].imageUrl = image
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }

    fileprivate func fillForm(withPendingUploadItem pendingUploadItem: PendingUploadItem) {
        if let image = pendingUploadItem.frontImage {
            if let index = index(forImageType: .front) {
                pictures[index].image = image.image
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        if let image = pendingUploadItem.ingredientsImage {
            if let index = index(forImageType: .ingredients) {
                pictures[index].image = image.image
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        if let image = pendingUploadItem.nutritionImage {
            if let index = index(forImageType: .nutrition) {
                pictures[index].image = image.image
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }

    @IBAction func didTapCellTakePictureButton(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? PictureTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        imageType = pictures[indexPath.row].imageType
        didTapTakePictureButton(sender)
    }

    override func postImageSuccess(image: UIImage, forImageType imageType: ImageType) {
        guard let pictureIndex = index(forImageType: imageType) else { return }

        pictures[pictureIndex].image = image
        tableView.reloadRows(at: [IndexPath(row: pictureIndex, section: 0)], with: .automatic)

        if imageType == .ingredients {
            delegate?.didPostIngredientImage()
        }
    }

    // we override but do NOT call super, because super will display the uploading banner, when we display the loading in the tableview
    override func showUploadingImage(forType: ImageType?, progress: Double?) {
        guard let pictureIndex = index(forImageType: imageType) else { return }
        pictures[pictureIndex].isUploading = true
        pictures[pictureIndex].uploadProgress = progress
        tableView.reloadRows(at: [IndexPath(row: pictureIndex, section: 0)], with: .automatic)
    }

    // we override but do NOT call super, because super will display the success banner, when we display the success in the tableview
    override func showSuccessUploadingImage(forType: ImageType?) {
        guard let pictureIndex = index(forImageType: imageType) else { return }
        pictures[pictureIndex].isUploading = false
        tableView.reloadRows(at: [IndexPath(row: pictureIndex, section: 0)], with: .automatic)
    }

    // we override and call super, because we want to show the error banner
    override func showErrorUploadingImage(forType: ImageType?) {
        guard let pictureIndex = index(forImageType: imageType) else {
            super.showErrorUploadingImage(forType: forType)
            return
        }
        pictures[pictureIndex].isUploading = false
        tableView.reloadRows(at: [IndexPath(row: pictureIndex, section: 0)], with: .automatic)

        super.showErrorUploadingImage(forType: forType)
    }
}

// MARK: - UITableViewDataSource
extension PictureTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PictureTableViewCell.self)) as? PictureTableViewCell else {
            fatalError("The cell is missing. No cell, no table.")
        }
        cell.configure(viewModel: pictures[indexPath.row])
        return cell
    }
}
