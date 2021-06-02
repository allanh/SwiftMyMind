//
//  StageProgressView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class StageProgressView: NiblessView {

    var numberOfStages: Int = 3
    var stageDescriptionList: [String] = ["採購建議", "採購申請", "送出審核"]
    var currentStageIndex: Int = 1
    var horizontalSpace: CGFloat = 40
    var indicatorDiameter: CGFloat = 20
    var lineHieght: CGFloat = 8
    var textFont: UIFont = .systemFont(ofSize: 14)
    var textHeight: CGFloat = 20
    var isProgressedColor: UIColor = UIColor(hex: "004477")
    var isNotProgressedColor: UIColor = .gray

    private var indicators: [CALayer] = []

    convenience init(numberOfStage: Int, stageNameList: [String], currentStageIndex: Int) {
        self.init(frame: .zero)
        self.numberOfStages = numberOfStage
        self.stageDescriptionList = stageNameList
        self.currentStageIndex = currentStageIndex
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    func layout() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        drawLines()
        drawIndicators()
        drawTexts()
        setNeedsLayout()
    }

    private func drawTexts() {
        for index in 0..<stageDescriptionList.count {
            let label = CATextLayer()
            let text = stageDescriptionList[index]
            let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: textFont])
            label.string = attributedString
            let pairedIndicatorFrame = indicators[index].frame
            let textWidth = text.width(withConstrainedHeight: textHeight, font: textFont)
            let frame = CGRect(x: pairedIndicatorFrame.midX - textWidth/2, y: pairedIndicatorFrame.maxY+10, width: textWidth, height: 20)
            label.frame = frame
            layer.addSublayer(label)
        }
    }

    private func drawIndicators() {
        let singleLineWidth = calculateSingleLineWidth()
        var xPosition = horizontalSpace/2

        for index in 0..<numberOfStages {
            let indicator = CALayer()
            indicator.frame = CGRect(x: xPosition, y: frame.midY - indicatorDiameter/2, width: indicatorDiameter, height: indicatorDiameter)
            let isProgressed = index <= currentStageIndex
            indicator.borderColor = isProgressed ? isProgressedColor.cgColor : isNotProgressedColor.cgColor

            indicator.backgroundColor = UIColor.white.cgColor
            indicator.cornerRadius = indicatorDiameter / 2
            indicator.borderWidth = indicatorDiameter / 4
            layer.addSublayer(indicator)
            xPosition += (singleLineWidth)
            indicators.append(indicator)
        }
    }

    private func drawLines() {
        let numberOfLines = max(numberOfStages-1, 0)
        let singleLineWidth = calculateSingleLineWidth()
        var xPosition: CGFloat = horizontalSpace/2 + indicatorDiameter/2
        let yPosition = frame.midY - lineHieght/2

        for index in 0..<numberOfLines {
            let lineLayer = CALayer()
            let lineFrame = CGRect(x: xPosition, y: yPosition, width: singleLineWidth, height: lineHieght)
            lineLayer.frame = lineFrame
            lineLayer.backgroundColor = isNotProgressedColor.cgColor
            layer.addSublayer(lineLayer)
            xPosition = lineFrame.maxX
            if index < currentStageIndex {
                lineLayer.backgroundColor = isProgressedColor.cgColor
            }
        }
    }

    private func calculateSingleLineWidth() -> CGFloat {
        let numberOfLines = max(numberOfStages-1, 0)
        let totalLineWidth: CGFloat = frame.width - horizontalSpace - indicatorDiameter*2
        let singleLineWidth = totalLineWidth / CGFloat(numberOfLines)
        return singleLineWidth
    }

}
