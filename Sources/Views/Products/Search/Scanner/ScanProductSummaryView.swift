//
//  ContinuousScanSummaryView.swift
//  OpenFoodFacts
//

import UIKit

class ScanProductSummaryView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandsLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nutriScoreView: NutriScoreView!
    @IBOutlet weak var novaGroupView: NovaGroupView!
    @IBOutlet weak var productImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ScanProductSummaryView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func fillIn(product: Product) {
        titleLabel.text = product.name

        if let imageUrl = product.frontImageSmallUrl ?? product.imageSmallUrl ??  product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            productImageView.kf.indicatorType = .activity
            productImageView.kf.setImage(with: url)
            productImageView.isHidden = false
        } else {
            productImageView.isHidden = true
        }

        brandsLabel.text = nil
        if let brands = product.brands, !brands.isEmpty {
            brandsLabel.text = brands.joined(separator: ", ")
        }
        quantityLabel.text = nil
        if let quantity = product.quantity, !quantity.isEmpty {
            quantityLabel.text = quantity
        }

        if let nutriscoreValue = product.nutriscore, let score = NutriScoreView.Score(rawValue: nutriscoreValue.uppercased()) {
            nutriScoreView.currentScore = score
            nutriScoreView.isHidden = false
        } else {
            nutriScoreView.isHidden = true
        }

        if let novaGroupValue = product.novaGroup,
            let novaGroup = NovaGroupView.NovaGroup(rawValue: novaGroupValue) {
            novaGroupView.novaGroup = novaGroup
            novaGroupView.isHidden = false
        } else {
            novaGroupView.isHidden = true
        }
    }

}
