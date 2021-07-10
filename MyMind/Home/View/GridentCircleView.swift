//
//  GridentCircleView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class GridentCircleView: UIView {
    let gradients: [CGColor]
    init(gradients: [CGColor]) {
        self.gradients = gradients
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.shouldRasterize = true
        return layer
    }()
    private lazy var maskLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        return layer
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradients
        maskLayer.frame = bounds
        maskLayer.cornerRadius = maskLayer.frame.width / 2
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            layer.addSublayer(gradientLayer)
            layer.mask = maskLayer
        }
    }
}
