//
//  PendingUploadTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SVProgressHUD

struct PendingUploadCellIds {
    static let item = "PendingUploadItemCell"
    static let info = "PendingUploadInfoCell"
}

class PendingUploadTableViewController: UITableViewController, DataManagerClient {
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    var dataManager: DataManagerProtocol!
    var items = [PendingUploadItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        items = dataManager.getItemsPendingUpload()

        if items.isEmpty {
            uploadButton.isEnabled = false
        } else {
            uploadButton.isEnabled = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "upload")!, style: .plain, target: self, action: #selector(PendingUploadTableViewController.uploadButtonTapped(_:)))
    }

    @IBAction func uploadButtonTapped(_ sender: UIBarButtonItem) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.showProgress(0.0, status: "pending-upload.hud.status".localized)

        dataManager.uploadPendingItems(mergeProcessor: PendingProductMergeProcessor()) { progress in
            if progress < 1.0 {
                SVProgressHUD.showProgress(progress, status: "pending-upload.hud.status".localized)
            } else {
                SVProgressHUD.showProgress(1.0, status: "pending-upload.hud.status".localized)
                SVProgressHUD.dismiss()
                SVProgressHUD.setDefaultMaskType(.none)
                self.items = self.dataManager.getItemsPendingUpload()
                self.tableView.reloadData()
                self.tabBarController?.tabBar.selectedItem?.badgeValue = self.items.isEmpty ? nil : "\(self.items.count)"
            }
        }
    }
}

// MARK: - Data Source

extension PendingUploadTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (items.isEmpty ? 0 : 1) + 1 // + 1 for info cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInfoSection(section) {
            return 1
        } else {
            return items.count
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = isInfoSection(indexPath.section) ? PendingUploadCellIds.info : PendingUploadCellIds.item
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)

        if id == PendingUploadCellIds.item {
            let item = items[indexPath.row]
            (cell as! PendingUploadItemCell).configure(with: item) // swiftlint:disable:this force_cast
        }

        return cell
    }

    private func isInfoSection(_ section: Int) -> Bool {
        return section > (items.isEmpty ? 0 : 1) - 1
    }
}
