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
import NotificationBanner

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

    fileprivate var questions: [RobotoffQuestion] = []
    fileprivate var questionIndex = 0
    fileprivate var viewController: FormTableViewController?

    fileprivate var bulletinManager: BLTNItemManager!

    lazy var successBanner = StatusBarNotificationBanner(title: "robotoff.answer-saved".localized, style: .success)

    override func awakeFromNib() {
        super.awakeFromNib()

        yesButton.setTitle("robotoff.yes".localized, for: .normal)
        noButton.setTitle("robotoff.no".localized, for: .normal)
        notSureButton.setTitle("robotoff.not-sure".localized, for: .normal)

        buttons.forEach { (button: UIButton) in
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textColor = UIColor.blue
            button.setTitleColor(.blue, for: .normal)
            if #available(iOS 13.0, *) {
                button.backgroundColor = UIColor.systemBackground
            } else {
                button.backgroundColor = UIColor.white
            }

        }

        yesImageView.image = UIImage(named: "robotoff_yes")
        noImageView.image = UIImage(named: "robotoff_no")
        notSureImageView.image = UIImage(named: "robotoff_question")

        imageViews.forEach { $0.isUserInteractionEnabled = true }
    }

    fileprivate func displayQuestion() {
        if self.questions.count > self.questionIndex {
            let question = questions[self.questionIndex]
            questionLabel.text = question.question
            questionSuggestionLabel.text = question.value

            setImageSelected(forAnnotation: -3)
        } else {
            if let barcode = questions.first?.barcode {
                NotificationCenter.default.post(name: .productChangesUploaded, object: nil, userInfo: ["barcode": barcode])
            }
        }
    }

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        self.viewController = viewController

        if let questions = formRow.value as? [RobotoffQuestion] {
            self.questions = questions
            self.questionIndex = 0
            self.displayQuestion()
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
        yesButton.setTitleColor(forAnnotation == 1 ? .green : .blue, for: .normal)

        //yesButton.titleLabel?.textColor = (forAnnotation == 1 ? .green : .blue)

        noImageView.image = UIImage(named: "robotoff_no" + (forAnnotation == -1 ? "_selected" : ""))
        yesButton.setTitleColor(forAnnotation == 1 ? .green : .blue, for: .normal)

        notSureImageView.image = UIImage(named: "robotoff_question" + (forAnnotation == 0 ? "_selected" : ""))
        yesButton.setTitleColor(forAnnotation == 1 ? .green : .blue, for: .normal)
    }

    fileprivate func postAnswer(withAnnotation: Int) {
        let insightId = questions[questionIndex].insightId

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

        buttons.forEach { $0.isEnabled = false }
        imageViews.forEach { $0.isUserInteractionEnabled = false }

        setImageSelected(forAnnotation: withAnnotation)
        self.viewController?.dataManager.postRobotoffAnswer(forInsightId: insightId, withAnnotation: withAnnotation) { [weak self] in
            guard let zelf = self else {
                return
            }

            zelf.successBanner.show()

            zelf.buttons.forEach { $0.isEnabled = true }
            zelf.imageViews.forEach { $0.isUserInteractionEnabled = true }

            zelf.questionIndex += 1
            zelf.displayQuestion()
        }
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
            if bulletinManager.isShowingBulletin {
                bulletinManager.dismissBulletin(animated: true)
            }
            bulletinManager = nil
        }
    }
}

class LoginToContributeRobotoffBLTPageItem: BLTNPageItem {

    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {

        let deactivateSwitch = UISwitch()
        deactivateSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableRobotoffWhenNotLoggedIn)
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
        UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableRobotoffWhenNotLoggedIn)
    }
}
