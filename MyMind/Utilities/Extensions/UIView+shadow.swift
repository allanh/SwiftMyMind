//
//  UIView+shadow.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIView {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 6,
        spread: CGFloat = 0)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
extension UIView {
    enum GradientDirection {
        case topDown, leftRight
    }
    func makeGradient(_ gradientColors: [CGColor], direction: GradientDirection = .leftRight, layerCornerRadius: CGFloat? = 0) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height-35)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = layerCornerRadius ?? 0
        gradientLayer.colors = gradientColors
        switch direction {
        case .leftRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .topDown:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        return gradientLayer
//        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor],
                     direction: GradientDirection = .leftRight, layerCornerRadius: CGFloat? = 0) {
        layer.frame = gradientFrame ?? self.bounds
        layer.frame.origin = .zero
        layer.cornerRadius = layerCornerRadius ?? 0

        let layerColorSet = colorSet.map { $0.cgColor }
        layer.colors = layerColorSet
        switch direction {
        case .leftRight:
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        case .topDown:
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
        }

        self.layer.insertSublayer(layer, at: 0)
    }
    
    func removeGradient() {
        layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
    }
}
