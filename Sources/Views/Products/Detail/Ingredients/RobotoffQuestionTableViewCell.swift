//
//  RobotoffQuestionTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 19/02/2020.
//  Copyright © 2020 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import BLTNBoard
import Cartography

class RobotoffQuestionTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionSuggestionLabel: UILabel!
    @IBOutlet weak var yesImageView: UIImageView!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var notSureImageView: UIImageView!

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var notSureButton: UIButton!

    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var buttons: [UIButton]!

    fileprivate var yesTapGesture: UITapGestureRecognizer?
    fileprivate var noTapGesture: UITapGestureRecognizer?
    fileprivate var notSureTapGesture: UITapGestureRecognizer?

    fileprivate var question: RobotoffQuestion?
    fileprivate var viewController: FormTableViewController?

    fileprivate var bulletinManager: BLTNItemManager!

    override func awakeFromNib() {
        super.awakeFromNib()

        yesButton.setTitle("robotoff.yes".localized, for: .normal)
        noButton.setTitle("robotoff.no".localized, for: .normal)
        notSureButton.setTitle("robotoff.not-sure".localized, for: .normal)

        buttons.forEach { (button: UIButton) in
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textColor = UIColor.black
        }

        yesImageView.image = UIImage(named: "robotoff_yes")
        noImageView.image = UIImage(named: "robotoff_no")
        notSureImageView.image = UIImage(named: "robotoff_question")

        imageViews.forEach { $0.isUserInteractionEnabled = true }
    }

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        self.viewController = viewController

        if let question = formRow.value as? RobotoffQuestion {
            self.question = question
            log.debug("robotoff we should configure the cell \(question)")

            questionLabel.text = question.question
            questionSuggestionLabel.text = question.value
        }

        self.yesTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapYes))
        yesImageView.addGestureRecognizer(yesTapGesture!)
        yesButton.addTarget(self, action: #selector(self.tapYes), for: .touchUpInside)

        self.noTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapNo))
        noImageView.addGestureRecognizer(noTapGesture!)
        noButton.addTarget(self, action: #selector(self.tapNo), for: .touchUpInside)

        self.notSureTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapNotSure))
        notSureImageView.addGestureRecognizer(notSureTapGesture!)
        notSureButton.addTarget(self, action: #selector(self.tapNotSure), for: .touchUpInside)

        setImageSelected(forAnnotation: -3)
    }

    override func dismiss() {
        super.dismiss()

        if let yesTapGesture = yesTapGesture {
            yesImageView.removeGestureRecognizer(yesTapGesture)
            self.yesTapGesture = nil
        }
        if let noTapGesture = noTapGesture {
            noImageView.removeGestureRecognizer(noTapGesture)
            self.noTapGesture = nil
        }
        if let notSureTapGesture = notSureTapGesture {
            notSureImageView.removeGestureRecognizer(notSureTapGesture)
            self.notSureTapGesture = nil
        }
    }

    fileprivate func setImageSelected(forAnnotation: Int) {
        yesImageView.image = UIImage(named: "robotoff_yes" + (forAnnotation == 1 ? "_selected" : ""))
        yesButton.titleLabel?.textColor = (forAnnotation == 1 ? UIColor(hex: "1876d2")! : UIColor.black)

        noImageView.image = UIImage(named: "robotoff_no" + (forAnnotation == -1 ? "_selected" : ""))
        noButton.titleLabel?.textColor = (forAnnotation == -1 ? UIColor(hex: "1876d2")! : UIColor.black)

        notSureImageView.image = UIImage(named: "robotoff_question" + (forAnnotation == 0 ? "_selected" : ""))
        notSureButton.titleLabel?.textColor = (forAnnotation == 0 ? UIColor(hex: "1876d2")! : UIColor.black)
    }

    fileprivate func postAnswer(withAnnotation: Int) {
        guard let insightId = question?.insightId else {
            return
        }

        if CredentialsController.shared.getUsername() == nil {

            let page = LoginToContributeRobotoffBLTPageItem(title: "robotoff.contribute-incentive.title".localized)

            page.actionButtonTitle = "robotoff.contribute-incentive.login".localized
            page.alternativeButtonTitle = "robotoff.contribute-incentive.not-now".localized

            page.actionHandler = { item in
                item.manager?.dismissBulletin()
                self.viewController?.showLogin()
            }
            page.alternativeHandler = { item in
                item.manager?.dismissBulletin()
            }

            bulletinManager = BLTNItemManager(rootItem: page)
            bulletinManager.showBulletin(in: UIApplication.shared)

            return
        }

        setImageSelected(forAnnotation: withAnnotation)
        self.viewController?.dataManager.postRobotoffAnswer(forInsightId: insightId, withAnnotation: withAnnotation)
    }

    @objc
    func tapYes() {
        postAnswer(withAnnotation: 1)
    }

    @objc
    func tapNo() {
        postAnswer(withAnnotation: -1)
    }

    @objc
    func tapNotSure() {
        postAnswer(withAnnotation: 0)
    }

    deinit {
        if bulletinManager != nil {
            bulletinManager.dismissBulletin(animated: true)
            bulletinManager = nil
        }
    }
}

class LoginToContributeRobotoffBLTPageItem: BLTNPageItem {

    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {

        let deactivateSwitch = UISwitch()
        deactivateSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableOffWhenNotLggedIn)
        deactivateSwitch.addTarget(self, action: #selector(changeSwitch(sender:)), for: .valueChanged)

        let switchLabel = UILabel()
        switchLabel.textAlignment = .right
        switchLabel.numberOfLines = 2
        switchLabel.text = "robotoff.settings.display-questions".localized

        let switchStackView = UIView()
        switchStackView.addSubview(switchLabel)
        switchStackView.addSubview(deactivateSwitch)

        constrain(switchStackView, switchLabel, deactivateSwitch) { (switchStackView, switchLabel, deactivateSwitch) in
            switchLabel.leading == switchStackView.leading
            switchLabel.centerY == switchStackView.centerY
            switchLabel.top >= switchStackView.top + 8
            switchLabel.bottom >= switchStackView.bottom - 8

            deactivateSwitch.leading == switchLabel.trailing + 8
            deactivateSwitch.trailing == switchStackView.trailing
            deactivateSwitch.centerY == switchStackView.centerY
        }

        var views: [UIView] = [switchStackView]

        let label = UILabel()
        label.numberOfLines = 0
        label.text = "robotoff.contribute-incentive.description".localized
        views.append(label)

        return views
    }

    @objc func changeSwitch(sender: UISwitch) {
        UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableOffWhenNotLggedIn)
    }
}
