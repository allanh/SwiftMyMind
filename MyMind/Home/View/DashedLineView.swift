//
//  DashedLineView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/15.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class DashedLineView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if bounds.height > bounds.width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = bounds.width

        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = bounds.height
        }

        let  dashes: [ CGFloat ] = [ 2, 2 ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)

        path.lineCapStyle = .butt
        UIColor.tertiaryLabel.set()
        path.stroke()
    }
}
