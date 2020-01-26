//
//  IngredientsAnalysisView.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 22/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import BLTNBoard
import Kingfisher
import Cartography

@IBDesignable class IngredientsAnalysisView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    var detail: IngredientsAnalysisDetail?
    fileprivate var gestureRecognizer: UITapGestureRecognizer?
    fileprivate var ingredientsList: [Ingredient]?

    func configure(detail: IngredientsAnalysisDetail, ingredientsList: [Ingredient]?) {
        self.backgroundColor = detail.color
        self.layer.cornerRadius = 5
        self.detail = detail
        self.ingredientsList = ingredientsList
        guard let url = URL(string: detail.icon) else { return }
        iconImageView.kf.setImage(with: url)
    }

    static func loadFromNib() -> IngredientsAnalysisView {
        let nib = UINib(nibName: "IngredientsAnalysisView", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! IngredientsAnalysisView
        return view
    }

    func configureGestureRecognizer() {
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        if let gestureRecognizer = self.gestureRecognizer {
            self.addGestureRecognizer(gestureRecognizer)
            self.isUserInteractionEnabled = true
        }
    }

    func removeGestureRecognizer() {
        if let validGesture = self.gestureRecognizer {
            self.removeGestureRecognizer(validGesture)
            self.gestureRecognizer = nil
        }
    }

    var bulletinManager: BLTNItemManager!

    deinit {
        if bulletinManager != nil {
            bulletinManager.dismissBulletin(animated: true)
            bulletinManager = nil
        }
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let detail = detail else {
            return
        }
        let page = AnalysisIconBLTPageItem(title: detail.title)

        page.requiresCloseButton = false

        page.detail = detail
        page.ingredientsList = ingredientsList
        page.iconImageBackgroundColor = self.detail?.color
        page.iconImage = self.iconImageView.image

        page.actionButtonTitle = "generic.ok".localized
        page.actionHandler = { item in
            item.manager?.dismissBulletin()
        }

        if bulletinManager != nil {
            bulletinManager.dismissBulletin(animated: false)
        }

        bulletinManager = BLTNItemManager(rootItem: page)
        bulletinManager.showBulletin(in: UIApplication.shared)

        page.imageView?.backgroundColor = self.backgroundColor
    }
}

class AnalysisIconBLTPageItem: BLTNPageItem {

    var ingredientsList: [Ingredient]?
    var detail: IngredientsAnalysisDetail?
    var iconImageBackgroundColor: UIColor?
    var iconImage: UIImage?

    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {

        let ivv = UIImageView()
        ivv.image = iconImage

        let ivb = UIView()
        ivb.backgroundColor = iconImageBackgroundColor
        ivb.layer.cornerRadius = 5
        ivb.addSubview(ivv)

        let ivc = UIView()
        ivc.addSubview(ivb)

        constrain(ivv, ivb, ivc) { (ivv, ivb, ivc) in
            ivc.width == 44
            ivc.height == 44
            ivv.edges == ivb.edges.inseted(by: 10)
            ivb.edges == ivc.edges
        }

        let deactivateSwitch = UISwitch()
        switch detail?.type {
        case .palmOil:
            deactivateSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayPalmOilStatus)
        case .vegan:
            deactivateSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayVeganStatus)
        case .vegetarian:
            deactivateSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayVegetarianStatus)
        default:
            deactivateSwitch.isHidden = true
        }
        deactivateSwitch.addTarget(self, action: #selector(changeSwitch(sender:)), for: .valueChanged)

        let switchLabel = UILabel()
        switchLabel.textAlignment = .right
        switchLabel.numberOfLines = 2
        switchLabel.text = String(format: "ingredients-analysis.display".localized, detail?.title.lowercased() ?? "")

        let switchStackView = UIView()
        switchStackView.addSubview(ivc)
        switchStackView.addSubview(switchLabel)
        switchStackView.addSubview(deactivateSwitch)

        constrain(switchStackView, ivc, switchLabel, deactivateSwitch) { (switchStackView, ivc, switchLabel, deactivateSwitch) in
            ivc.leading == switchStackView.leading + 8
            ivc.centerY == switchStackView.centerY
            ivc.top >= switchStackView.top + 8
            ivc.bottom >= switchStackView.bottom - 8

            switchLabel.leading == ivc.trailing + 8
            switchLabel.centerY == ivc.centerY
            switchLabel.top >= switchStackView.top + 8
            switchLabel.bottom >= switchStackView.bottom - 8

            deactivateSwitch.leading == switchLabel.trailing + 8
            deactivateSwitch.trailing == switchStackView.trailing - 8
            deactivateSwitch.centerY == ivc.centerY
        }

        var views: [UIView] = [switchStackView]

        if let detail = detail {

            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.numberOfLines = 0

            let descriptionLabel = UILabel()
            descriptionLabel.numberOfLines = 0
            descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)

            if detail.type == .palmOil {
                if detail.tag.contains("status-unknown") {
                    descriptionLabel.text = String(format: InfoRowKey.ingredientsUnknownStatus.localizedString, detail.title.lowercased())
                    views.append(descriptionLabel)
                }
            } else {
                if detail.tag.contains("non") || detail.tag.contains("maybe") || detail.tag.contains("may-contain") {
                    titleLabel.text = String(format: InfoRowKey.ingredientsInThisProduct.localizedString, detail.title.lowercased())
                    descriptionLabel.text = self.getListIngredients(status: detail.tag.contains("non") ? "no" : "maybe")

                    let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
                    verticalStackView.axis = .vertical
                    verticalStackView.spacing = 4
                    views.append(verticalStackView)
                } else if detail.tag.contains("status-unknown") {
                    descriptionLabel.text = String(format: InfoRowKey.ingredientsUnknownStatus.localizedString, detail.title.lowercased())
                    views.append(descriptionLabel)
                } else {
                    descriptionLabel.text = String(format: InfoRowKey.ingredientsInThisProductAre.localizedString, detail.title.lowercased())
                    views.append(descriptionLabel)
                }
            }
        }

        return views
    }

    @objc func changeSwitch(sender: UISwitch) {
        switch detail?.type {
        case .palmOil:
            UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayPalmOilStatus)
        case .vegan:
        UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayVeganStatus)
        case .vegetarian:
        UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayVegetarianStatus)
        default:
            break
        }
    }

    func getListIngredients(status: String) -> String {
        guard let detail = detail else {
            return ""
        }

        guard let list = self.ingredientsList else {
            return ""
        }
        return list.compactMap { ingredient in
            if detail.type == .vegetarian {
                if ingredient.vegetarian != nil && ingredient.vegetarian == status {
                    return ingredient.text?.replacingOccurrences(of: "_", with: "")
                }
            } else if ingredient.vegan != nil && ingredient.vegan == status {
                return ingredient.text?.replacingOccurrences(of: "_", with: "")
            }
            return nil
        }.joined(separator: ", ")
    }
}
