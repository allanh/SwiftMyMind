//
//  ScannerOverlayPreviewLayer.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import AVFoundation
import UIKit

public class ScannerOverlayPreviewLayer: AVCaptureVideoPreviewLayer {

    // MARK: - OverlayScannerPreviewLayer
    public var cornerLength: CGFloat = 30
    public var maskContainerCornerRadius: CGFloat = 10

    public var lineWidth: CGFloat = 6
    public var lineColor: UIColor = .white
    public var lineCap: CAShapeLayerLineCap = .round

    public var maskSize: CGSize = CGSize(width: 200, height: 200)

    public var rectOfInterest: CGRect {
        metadataOutputRectConverted(fromLayerRect: maskContainer)
    }

    public override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    private var maskContainer: CGRect {
        CGRect(x: (bounds.width / 2) - (maskSize.width / 2),
        y: (bounds.height / 2) - (maskSize.height / 2),
        width: maskSize.width, height: maskSize.height)
    }

    // MARK: - Drawing
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        // MARK: - Background Mask
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRoundedRect(in: maskContainer, cornerWidth: maskContainerCornerRadius, cornerHeight: maskContainerCornerRadius)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = backgroundColor
        maskLayer.fillRule = .evenOdd

        addSublayer(maskLayer)

        // MARK: - Edged Corners
        if maskContainerCornerRadius > cornerLength { maskContainerCornerRadius = cornerLength }
        if cornerLength > maskContainer.width / 2 { cornerLength = maskContainer.width / 2 }

        let upperLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.minY)
        let upperRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.minY)
        let lowerRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.maxY)
        let lowerLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.maxY)

        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(
            withCenter: upperLeftPoint.offsetBy(dx: maskContainerCornerRadius, dy: maskContainerCornerRadius),
            radius: maskContainerCornerRadius,
            startAngle: .pi,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))

        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(
            withCenter: upperRightPoint.offsetBy(dx: -maskContainerCornerRadius, dy: maskContainerCornerRadius),
            radius: maskContainerCornerRadius,
            startAngle: 3 * .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))

        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(
            withCenter: lowerRightPoint.offsetBy(dx: -maskContainerCornerRadius, dy: -maskContainerCornerRadius),
            radius: maskContainerCornerRadius,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))

        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(
            withCenter: lowerLeftPoint.offsetBy(dx: maskContainerCornerRadius, dy: -maskContainerCornerRadius),
            radius: maskContainerCornerRadius,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))

        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = lineCap

        addSublayer(shapeLayer)
    }
}

internal extension CGPoint {

    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
