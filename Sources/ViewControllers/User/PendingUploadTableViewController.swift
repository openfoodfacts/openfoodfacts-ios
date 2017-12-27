//
//  PendingUploadTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

struct PendingUploadCellIds {
    static let item = "PendingUploadItemCell"
    static let info = "PendingUploadInfoCell"
}

class PendingUploadTableViewController: UITableViewController, DataManagerClient {
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    var dataManager: DataManagerProtocol!
    private lazy var _items: [PendingUploadItem] = dataManager.getItemsPendingUpload()
    var items: [PendingUploadItem] {
        set {
            _items = newValue
        }
        get {
            if _items.isEmpty {
                uploadButton.isEnabled = false
            } else {
                uploadButton.isEnabled = true
            }

            return _items
        }
    }
}

// MARK: - Data Source

extension PendingUploadTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count + 1 // + 1 for info cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInfoSection(section) {
            return 1
        } else {
            return items.count
        }
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
        return section > items.count - 1
    }
}
