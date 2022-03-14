//
//  MyMindPieChartView.swift
//  AppearancePlayground
//
//  Created by Nelson Chan on 2021/12/7.
//

import UIKit

class MyMindPieChartView: UIView {
    var data: MyMindPieChartData = MyMindPieChartData.mock {
        didSet {
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    private let sliceOffset: CGFloat = -.pi / 2
    private func startAngle(for index: Int) -> CGFloat {
        switch index {
        case 0:
            return sliceOffset
        default:
            let ratio: CGFloat = data.slices[..<index].map({$0.ratio}).reduce(0.0, +) / data.slices.map({$0.ratio}).reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    private func endAngle(for index: Int) -> CGFloat {
        switch index {
        case data.slices.count - 1:
          return sliceOffset + 2 * .pi
        default:
            let ratio: CGFloat = data.slices[..<(index + 1)].map({$0.ratio}).reduce(0.0, +) / data.slices.map({$0.ratio}).reduce(0.0, +)
          return sliceOffset + 2 * .pi * ratio
        }
    }
    private func path(in rect: CGRect, startAngle: CGFloat, endAngle: CGFloat, ratio: CGFloat?) -> UIBezierPath {
        let path = UIBezierPath()
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        if let ratio = ratio, ratio != 0.0 {
            path.move(to: CGPoint(x: center.x + cos(startAngle) * radius, y: center.y + sin(startAngle) * radius))
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: CGPoint(x: center.x + cos(CGFloat(endAngle)) * radius * ratio, y: center.y + sin(CGFloat(endAngle)) * radius * ratio))
            path.addArc(withCenter: center, radius: radius * ratio, startAngle: endAngle, endAngle: startAngle, clockwise: false)

            path.addLine(to: CGPoint(x: center.x + cos(startAngle) * radius * ratio, y: center.y + sin(startAngle) * radius * ratio))
        } else {
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
        }
        return path
    }
    private func point(in rect: CGRect, angle: CGFloat) -> CGPoint {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let point = CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)
        return point
    }

    private func drawLinearGradient(inside path:UIBezierPath, start:CGPoint, end:CGPoint, colors:[UIColor]) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        ctx.saveGState()
        defer { ctx.restoreGState() } // clean up graphics state changes when the method returns

        path.addClip() // use the path as the clipping region

        let cgColors = colors.map({ $0.cgColor })
        guard let gradient = CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: nil)
            else { return }

        ctx.drawLinearGradient(gradient, start: start, end: end, options: [])
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        if data.slices.count > 0 {
            for index in 0..<data.slices.count {
                let startAngle = startAngle(for: index)
                let endAngle = endAngle(for: index)
                let slicePath = path(in: bounds, startAngle: startAngle, endAngle: endAngle, ratio: data.holeRatio)
                drawLinearGradient(inside: slicePath, start: point(in: bounds, angle: startAngle) , end: point(in: bounds, angle: endAngle), colors: data.slices[index].colors)
            }
        } else {
            let slicePath = path(in: bounds, startAngle: -.pi/2, endAngle: .pi*1.5, ratio: data.holeRatio)
            drawLinearGradient(inside: slicePath, start: .zero , end: CGPoint(x: bounds.maxX, y: bounds.maxY), colors: [UIColor(red: 22.0/255.0, green: 52.0/255.0, blue: 85.0/255.0, alpha: 1.0), UIColor(red: 22.0/255.0, green: 52.0/255.0, blue: 85.0/255.0, alpha: 1.0)])
        }
    }
}
