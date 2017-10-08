//
//  PictureTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class PictureTableViewController: TakePictureViewController {
    @IBOutlet weak var tableView: UITableView!
    var pictures = [PictureViewModel]()
    private var currentPictureForCell: IndexPath?

    override func viewDidLoad() {
        tableView.isScrollEnabled = false
        pictures.append(PictureViewModel(imageType: .front))
        pictures.append(PictureViewModel(imageType: .ingredients))
        pictures.append(PictureViewModel(imageType: .nutrition))
        currentPictureForCell = nil
    }

    @IBAction func didTapCellTakePictureButton(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? PictureTableViewCell else { return; }
        guard let indexPath = tableView.indexPath(for: cell) else { return; }
        currentPictureForCell = indexPath
        imageType = pictures[indexPath.row].imageType
        didTapTakePictureButton(sender)
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

// MARK: - TakePictureController extension
extension PictureTableViewController {
    override func postImageSuccess(image: UIImage) {
        guard let indexPath = currentPictureForCell else { return; }
        pictures[indexPath.row].image = image
        tableView.reloadRows(at: [indexPath], with: .automatic)
        currentPictureForCell = nil
    }
}
