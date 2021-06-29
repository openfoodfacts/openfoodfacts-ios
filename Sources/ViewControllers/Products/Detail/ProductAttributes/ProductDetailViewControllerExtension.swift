//
//  ProductDetailViewControllerExtension.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 11/3/20.
//
import FloatingPanel

extension ProductDetailViewController {
    // MARK: - ProductAttributes FloatingPanel setup
    func configureFloatingPanel() {
        productAttributeController = ProductAttributeViewController()
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.contentMode = .fitToBounds

        // Add the floating panel view to the controller's view on top of other views.
        self.view.addSubview(floatingPanelController.view)
        floatingPanelController.view.frame = self.view.bounds

        // In addition, Auto Layout constraints are highly recommended.
        // Constraint the fpc.view to all four edges of your controller's view.
        // It makes the layout more robust on trait collection change.
        floatingPanelController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          floatingPanelController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          floatingPanelController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          floatingPanelController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          floatingPanelController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
        ])

        floatingPanelController.set(contentViewController: productAttributeController)

        floatingPanelController.surfaceView.backgroundColor = .white
        floatingPanelController.surfaceView.cornerRadius = 9.0
        floatingPanelController.surfaceView.shadowHidden = false
        // Add a gesture to hide the floating panel
        let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideSummaryView(_:)))
        gestureDown.numberOfTouchesRequired = 1
        gestureDown.direction = .down
        floatingPanelController.surfaceView.addGestureRecognizer(gestureDown)
        floatingPanelController.surfaceView.isUserInteractionEnabled = true

        floatingPanelController.addPanel(toParent: self)
    }

    // MARK: - Gesture recognizers
    @objc func hideSummaryView(_ sender: UISwipeGestureRecognizer) {
        hideFloatingPanel()
    }

    func hideFloatingPanel() {
        productAttributeController.attributeView = nil
        productAttributeController.resetView()
        floatingPanelController.move(to: FloatingPanelPosition.hidden, animated: true)
    }

}
extension ProductDetailViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        productAttributeFloatingPanelLayout.contentViewOffset = productAttributeController.totalStackViewHeight
        return productAttributeFloatingPanelLayout
    }

    func floatingPanelDidChangePosition(_ floatingPanelVC: FloatingPanelController) {
        if floatingPanelVC.position != .full {
            self.view.endEditing(true)
        }
    }

}

class ProductAttributeFloatingPanelLayout: FloatingPanelLayout {

    var contentViewOffset: CGFloat = 0.0

    public var initialPosition: FloatingPanelPosition {
        return .hidden
    }

    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.half]
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .tip: return 112.0 + 16.0
        case .half: return contentViewOffset + 24.0
        default: return nil
        }
    }
}

extension ProductDetailViewController: AttributeTableViewCellDelegate {
    func attributeTableViewCellTapped(_ sender: AttributeTableViewCell, _ attributeView: AttributeView) {
        productAttributeController.attributeView = attributeView
        productAttributeController.configureSubviews()
        floatingPanelController.move(to: FloatingPanelPosition.half, animated: true)
    }
}
