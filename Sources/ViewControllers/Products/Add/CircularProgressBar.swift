//
//  CircularProgressBar.swift
//  attendance-manager
//
//  Created by Yogesh Manghnani on 02/05/18.
//  Copyright © 2018 Yogesh Manghnani. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
    }

// MARK: - Public

    public var lineWidth: CGFloat = 5 {
        didSet {
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }

    public var labelSize: CGFloat = 20 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.sizeToFit()
            configLabel()
        }
    }

    public var safePercent: Int = 100 {
        didSet {
            setForegroundLayerColorForSafePercent()
        }
    }

    public var wholeCircleAnimationDuration: Double = 2

    public var lineBackgroundColor: UIColor = .gray

    public var lineColor: UIColor = .red

    public var lineFinishColor: UIColor = .green

    public func setProgress(to progressConstant: Double, withAnimation: Bool) {

        var progress: Double {
            if progressConstant > 1 {
                return 1
            } else if progressConstant < 0 {
                return 0
            } else {
                return progressConstant
            }
        }

        let animationDuration = wholeCircleAnimationDuration * progress

        foregroundLayer.strokeEnd = CGFloat(progress)

        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = animationDuration
            foregroundLayer.add(animation, forKey: "foregroundAnimation")

        var currentTime: Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= animationDuration {
                timer.invalidate()
            } else {
                currentTime += 0.05
                let percent = currentTime/2 * 100
                self.label.text = "\(Int(progress * percent))"
                self.setForegroundLayerColorForSafePercent()
                self.configLabel()
            }
        }
        timer.fire()
        } else {
            let percent = 100.0
            self.label.text = "\(Int(progress * percent))"
            self.setForegroundLayerColorForSafePercent()
            self.configLabel()

        }
    }

// MARK: Private

    private var label = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        if self.frame.width < self.frame.height {
            return (self.frame.width - lineWidth) / 2
        } else {
            return (self.frame.height - lineWidth) / 2
        }
    }

    private var pathCenter: CGPoint {
        self.convert(self.center, from: self.superview)
    }

    private func makeBar() {
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }

    private func drawBackgroundLayer() {
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = lineBackgroundColor.cgColor
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
    }

    private func drawForegroundLayer() {

        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle

        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = lineColor.cgColor
        foregroundLayer.strokeEnd = 0

        self.layer.addSublayer(foregroundLayer)

    }

    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = pathCenter
        return label
    }

    private func configLabel() {
        label.sizeToFit()
        label.center = pathCenter
    }

    private func setForegroundLayerColorForSafePercent() {
        if Int(label.text!)! >= self.safePercent {
            self.foregroundLayer.strokeColor = lineFinishColor.cgColor
        } else {
            self.foregroundLayer.strokeColor = lineColor.cgColor
        }
    }

    private func setupView() {
        makeBar()
        self.addSubview(label)
    }

    //Layout Sublayers

    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }

}
