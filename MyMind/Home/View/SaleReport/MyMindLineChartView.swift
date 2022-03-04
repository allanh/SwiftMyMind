//
//  MyMindLineChartView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/12/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import SwiftUI
struct MyMindLineChartData {
    let points: [CGPoint]
    let gradientColors: [UIColor]
    let gradientLocations: [NSNumber]
    var gradientStartPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    var gradientEndPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    var strokeColor: UIColor = UIColor(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    var strokeWidth: CGFloat = 3
    static var empty: MyMindLineChartData = MyMindLineChartData(points: [], gradientColors: [UIColor.white, UIColor.black], gradientLocations: [NSNumber(value: 0), NSNumber(value: 1)])
}

class MyMindLineChartView: UIView {

    var data: MyMindLineChartData = .empty {
        didSet {
            setNeedsDisplay()
        }
    }
    var verticalLinesCount: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    var verticalLineInsets: Int = 16 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var maximum: CGFloat {
        get {
            let max = data.points.map{ $0.y }.sorted{ $0 > $1}.first ?? 0
            if max == 0 {
                return 1000
            }
            return max
        }
    }
    private var minimum: CGFloat {
        get {
            let min = data.points.map{ $0.y }.sorted{ $0 < $1}.first ?? 0
            return max(min, 0)
        }
    }

    private var path: UIBezierPath {
        get {
            let path: UIBezierPath = UIBezierPath()
            let heightRatio: CGFloat = (frame.size.height)/(maximum-minimum)
            let itemWidth = bounds.width/CGFloat((data.points.count > 1) ? data.points.count - 1 : 1)
            let drawPoints = data.points.map { origin in
                return CGPoint(x: (origin.x*itemWidth), y: bounds.maxY - (origin.y - minimum)*heightRatio)
            }
            var previousPoint: CGPoint?
            var isFirst = true
            for index in 0..<drawPoints.count {
                let point = drawPoints[index]
                if let previousPoint = previousPoint {
                    let midPoint = CGPoint(
                        x: (point.x + previousPoint.x) / 2,
                        y: (point.y + previousPoint.y) / 2
                    )
                    if isFirst {
                        path.addLine(to: midPoint)
                        isFirst = false
                    } else if index == drawPoints.count - 1{
                        path.addQuadCurve(to: point, controlPoint: midPoint)
                    } else {
                        path.addQuadCurve(to: midPoint, controlPoint: previousPoint)
                    }
                }
                else {
                    path.move(to: point)
                }
                previousPoint = point
            }
            return path
        }
    }
    private var closedPath: UIBezierPath {
        get {
            let path: UIBezierPath = UIBezierPath()
            let heightRatio: CGFloat = bounds.height/(maximum-minimum)
            let itemWidth = bounds.width/CGFloat((data.points.count > 1) ? data.points.count - 1 : 1)
            let drawPoints = data.points.map { origin in
                return CGPoint(x: (origin.x*itemWidth), y: bounds.maxY - (origin.y - minimum)*heightRatio)
            }
            var previousPoint: CGPoint?
            var isFirst = true
            for index in 0..<drawPoints.count {
                let point = drawPoints[index]
                if let previousPoint = previousPoint {
                    let midPoint = CGPoint(
                        x: (point.x + previousPoint.x) / 2,
                        y: (point.y + previousPoint.y) / 2
                    )
                    if isFirst {
                        path.addLine(to: midPoint)
                        isFirst = false
                    } else if index == drawPoints.count - 1{
                        path.addQuadCurve(to: point, controlPoint: midPoint)
                    } else {
                        path.addQuadCurve(to: midPoint, controlPoint: previousPoint)
                    }
                }
                else {
                    if point.y != bounds.maxY {
                        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                        path.addLine(to: point)
                    } else {
                        path.move(to: point)
                    }
                }
                previousPoint = point
            }
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            return path
        }
    }
    let gradientLayer : CAGradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        backgroundColor = .clear
        gradientLayer.frame = bounds
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
   }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = closedPath.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        gradientLayer.locations = data.gradientLocations
        gradientLayer.colors = data.gradientColors.map{$0.cgColor}
        gradientLayer.startPoint = data.gradientStartPoint
        gradientLayer.endPoint = data.gradientEndPoint
        gradientLayer.mask = shapeLayer
        data.strokeColor.setStroke()
        
        let path = UIBezierPath(cgPath: path.cgPath)
        path.lineWidth = data.strokeWidth
        path.stroke()
        
        let verticalLinePath = UIBezierPath()
        let startOffset: CGFloat = CGFloat(verticalLineInsets)
        let width: CGFloat = (bounds.width - CGFloat(verticalLineInsets*2))/CGFloat(verticalLinesCount-1)
        for index in 0..<verticalLinesCount{
            verticalLinePath.move(to: CGPoint(x: startOffset+width*CGFloat(index), y: bounds.minY))
            verticalLinePath.addLine(to: CGPoint(x: startOffset+width*CGFloat(index), y: bounds.maxY))
        }
        verticalLinePath.lineWidth = 1
        
        let pattern: [CGFloat] = [5.0, 2.0]
        verticalLinePath.setLineDash(pattern, count: 2, phase: 0)
        UIColor(hex: "4b7b9c").setStroke()
        verticalLinePath.stroke()
    }
}
