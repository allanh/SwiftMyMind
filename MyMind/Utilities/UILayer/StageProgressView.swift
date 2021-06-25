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
    var stageDescriptionList: [String] = []
    var currentStageIndex: Int = 1
    var horizontalSpace: CGFloat = 80
    var indicatorDiameter: CGFloat = 20
    var lineHieght: CGFloat = 8
    var textFont: UIFont = .systemFont(ofSize: 14)
    var textHeight: CGFloat = 20
    var isProgressedColor: UIColor = UIColor(hex: "004477")
    var isNotProgressedColor: UIColor = .gray
    private let adjustedMidYSpace: CGFloat = 10

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
        indicators.removeAll()
        drawLines()
        drawIndicators()
        drawTexts()
    }

    private func drawTexts() {
        guard stageDescriptionList.count == indicators.count else { return }
        for index in 0..<stageDescriptionList.count {
            let label = CATextLayer()
            let text = stageDescriptionList[index]
            let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: textFont])
            label.string = attributedString
            let pairedIndicatorFrame = indicators[index].frame
            let textWidth = text.width(withConstrainedHeight: textHeight, font: textFont)
            let frame = CGRect(x: pairedIndicatorFrame.midX - textWidth/2, y: pairedIndicatorFrame.maxY+10, width: textWidth, height: 20)
            label.frame = frame
            label.contentsScale = UIScreen.main.scale
            layer.addSublayer(label)
        }
    }

    private func drawIndicators() {
        let singleLineWidth = calculateSingleLineWidth()
        var xPosition = horizontalSpace/2

        for index in 0..<numberOfStages {
            let indicator = CALayer()
            indicator.frame = CGRect(
                x: xPosition,
                y: frame.midY - indicatorDiameter/2 - adjustedMidYSpace,
                width: indicatorDiameter,
                height: indicatorDiameter)
            
            let isProgressed = index <= currentStageIndex
            indicator.borderColor = isProgressed ? isProgressedColor.cgColor : isNotProgressedColor.cgColor

            indicator.backgroundColor = UIColor.white.cgColor
            indicator.cornerRadius = indicatorDiameter / 2
            indicator.borderWidth = indicatorDiameter / 4
            layer.addSublayer(indicator)
            indicator.contentsScale = UIScreen.main.scale
            xPosition += (singleLineWidth)
            indicators.append(indicator)
        }
    }

    private func drawLines() {
        let numberOfLines = max(numberOfStages-1, 0)
        let singleLineWidth = calculateSingleLineWidth()
        var xPosition: CGFloat = horizontalSpace/2 + indicatorDiameter/2
        let yPosition = frame.midY - lineHieght/2 - adjustedMidYSpace

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
            lineLayer.contentsScale = UIScreen.main.scale
        }
    }

    private func calculateSingleLineWidth() -> CGFloat {
        let numberOfLines = max(numberOfStages-1, 0)
        let totalLineWidth: CGFloat = frame.width - horizontalSpace - indicatorDiameter
        let singleLineWidth = totalLineWidth / CGFloat(numberOfLines)
        return singleLineWidth
    }

}
