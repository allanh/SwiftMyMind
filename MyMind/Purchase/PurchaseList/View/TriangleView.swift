//
//  TriangleView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    /// Make sure change this property in main thread.
    var fillColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: .zero)
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.closePath()

        context.setFillColor(fillColor.cgColor)
        context.fillPath()
    }

}
