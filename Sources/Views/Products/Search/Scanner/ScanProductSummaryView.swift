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
    @IBOutlet weak var environmentImpactImageView: UIImageView!
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
        accessibilityIdentifier = AccessibilityIdentifiers.Scan.productSummaryView
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func setup(with adaptor: ScanProductSummaryViewAdaptor) {
        titleLabel.text = adaptor.title
        setQuantity(quantity: adaptor.quantityText)
        setProductImageView(imageURL: adaptor.productImageURL)
        setBrands(brands: adaptor.brands)
        setNutriScore(nutriscore: adaptor.nutriScore)
        setNovaGroup(novaGroup: adaptor.novaGroup)
        setEnvironmentImpactImageView(image: adaptor.environmentalImage)
    }

    private func setEnvironmentImpactImageView(image: UIImage?) {
        environmentImpactImageView.image = image
        environmentImpactImageView.isHidden = (image == nil)
    }

    private func setProductImageView(imageURL: URL?) {
        guard let url = imageURL else {
            productImageView.isHidden = true
            return
        }
        productImageView.kf.indicatorType = .activity
        productImageView.kf.setImage(with: url)
        productImageView.isHidden = false
    }

    private func setQuantity(quantity: String?) {
        quantityLabel.text = quantity
        quantityLabel.isHidden = (quantity == nil)
    }

    private func setBrands(brands: String?) {
        brandsLabel.text = brands
        brandsLabel.isHidden = (brands == nil)
    }

    private func setNutriScore(nutriscore: NutriScoreView.Score?) {
        if let score = nutriscore {
            nutriScoreView.currentScore = score
            nutriScoreView.isHidden = false
        } else {
            nutriScoreView.isHidden = true
        }
    }

    private func setNovaGroup(novaGroup: NovaGroupView.NovaGroup?) {
        if let novaGroup = novaGroup {
            novaGroupView.novaGroup = novaGroup
            novaGroupView.isHidden = false
        } else {
            novaGroupView.isHidden = true
        }
    }

}
