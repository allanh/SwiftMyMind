//
//  GradientView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//
import UIKit

class GradientView: UIView {

    let gradient : CAGradientLayer = CAGradientLayer()
    private let gradientStartColor: UIColor
    private let gradientEndColor: UIColor

    init(gradientStartColor: UIColor, gradientEndColor: UIColor) {
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = [gradientEndColor.cgColor, gradientStartColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)

        let cornerRadius = layer.cornerRadius
        let maskedCorners = layer.maskedCorners
        let roundingCorners = UIRectCorner(rawValue: maskedCorners.rawValue)
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        gradient.mask = shapeLayer

        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}
