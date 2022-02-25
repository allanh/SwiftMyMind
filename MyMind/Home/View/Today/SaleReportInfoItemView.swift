//
//  SaleReportInfoItemView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class SaleReportInfoItemView: NiblessView {
    // 數量或總額
    enum ItemType {
        case quantity, amount
        
        func getYesterdayTitleString(infoType: SaleReportInfoView.InfoType) -> String {
            switch infoType {
            case .sale:
                return self == .quantity ? "昨日銷售" : "昨日總額"
            case .canceled:
                return self == .quantity ? "昨日取消" : "昨日取消"
            case .sale_return:
                return self == .quantity ? "昨日退貨" : "昨日退貨"
            }
        }
    }
    var hierarchyNotReady: Bool = true
    let saleReports: SaleReports?
    let infoType: SaleReportInfoView.InfoType
    let itemType: ItemType
    init(frame: CGRect, saleReports: SaleReports?, type: SaleReportInfoView.InfoType, itemType: ItemType) {
        self.saleReports = saleReports
        self.infoType = type
        self.itemType = itemType
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        backgroundColor = UIColor(hex: "f1f8fe")
        hierarchyNotReady = false
    }
    private let quantityTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = .white
        $0.backgroundColor = UIColor(patternImage: UIImage(named: "today_label")!)
        $0.font = .pingFangTCRegular(ofSize: 12)
    }
    private let quantityLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 24)
        $0.textColor = .prussianBlue
        $0.sizeToFit()
    }

    private let quantityRatioLabel: EdgeInsetLabel = EdgeInsetLabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textAlignment = .left
        $0.textColor = .prussianBlue
        $0.backgroundColor = .prussianBlue.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.textInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    private let yesterdayQuantityLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .brownGrey
        $0.sizeToFit()
    }
    private let seperator: DashedLineView = DashedLineView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    private let transformedTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .brownGrey
        $0.text = "轉單"
    }
    private let transformedValueLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 12)
        $0.textAlignment = .right
        $0.textColor = .emperor
        $0.sizeToFit()
    }
    private let shippedTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .brownGrey
        $0.text = "寄倉"
    }
    private let shippedValueLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 12)
        $0.textAlignment = .right
        $0.textColor = .emperor
        $0.sizeToFit()
    }
}
/// helper
extension SaleReportInfoItemView {
    private func arrangeView() {
        addSubview(quantityTitleLabel)
        addSubview(quantityRatioLabel)
        addSubview(quantityLabel)
        addSubview(yesterdayQuantityLabel)
        addSubview(seperator)
        addSubview(transformedTitleLabel)
        addSubview(transformedValueLabel)
        addSubview(shippedTitleLabel)
        addSubview(shippedValueLabel)
        var saleAmountDivisor: Float = .zero, returnAmountDivisor: Float = .zero, canceledAmountDivisor: Float = .zero
        var saleQuantityDivisor: Float = .zero, returnQuantityDivisor: Float = .zero, canceledQuantityDivisor: Float = .zero
        if let yesterdayTransformedSaleReport = saleReports?.yesterdayTransformedSaleReport {
            saleAmountDivisor += yesterdayTransformedSaleReport.saleAmount
            returnAmountDivisor += yesterdayTransformedSaleReport.returnAmount
            canceledAmountDivisor += yesterdayTransformedSaleReport.canceledAmount
            saleQuantityDivisor += Float(yesterdayTransformedSaleReport.saleQuantity)
            returnQuantityDivisor += Float(yesterdayTransformedSaleReport.returnQuantity)
            canceledQuantityDivisor += Float(yesterdayTransformedSaleReport.canceledQuantity)
        }
        if let yesterdayShippedSaleReport = saleReports?.yesterdayShippedSaleReport {
            saleAmountDivisor += yesterdayShippedSaleReport.saleAmount
            returnAmountDivisor += yesterdayShippedSaleReport.returnAmount
            canceledAmountDivisor += yesterdayShippedSaleReport.canceledAmount
            saleQuantityDivisor += Float(yesterdayShippedSaleReport.saleQuantity)
            returnQuantityDivisor += Float(yesterdayShippedSaleReport.returnQuantity)
            canceledQuantityDivisor += Float(yesterdayShippedSaleReport.canceledQuantity)
        }
        var saleAmountDividend: Float = .zero, returnAmountDividend: Float = .zero, canceledAmountDividend: Float = .zero
        var saleQuantityDividend: Float = .zero, returnQuantityDividend: Float = .zero, canceledQuantityDividend: Float = .zero
        if let todayTransformedSaleReport = saleReports?.todayTransformedSaleReport {
            saleAmountDividend += todayTransformedSaleReport.saleAmount
            returnAmountDividend += todayTransformedSaleReport.returnAmount
            canceledAmountDividend += todayTransformedSaleReport.canceledAmount
            saleQuantityDividend += Float(todayTransformedSaleReport.saleQuantity)
            returnQuantityDividend += Float(todayTransformedSaleReport.returnQuantity)
            canceledQuantityDividend += Float(todayTransformedSaleReport.canceledQuantity)
        }
        if let todayShippedSaleReport = saleReports?.todayShippedSaleReport {
            saleAmountDividend += todayShippedSaleReport.saleAmount
            returnAmountDividend += todayShippedSaleReport.returnAmount
            canceledAmountDividend += todayShippedSaleReport.canceledAmount
            saleQuantityDividend += Float(todayShippedSaleReport.saleQuantity)
            returnQuantityDividend += Float(todayShippedSaleReport.returnQuantity)
            canceledQuantityDividend += Float(todayShippedSaleReport.canceledQuantity)
        }
        var saleAmountRatio: Float = .zero
        if saleAmountDivisor != .zero && saleAmountDividend != .zero {
            saleAmountRatio = (saleAmountDividend-saleAmountDivisor)/saleAmountDivisor
        }
        var saleQuantityRatio: Float = .zero
        if saleQuantityDivisor != .zero && saleQuantityDividend != .zero {
            saleQuantityRatio = (saleQuantityDividend-saleQuantityDivisor)/saleQuantityDivisor
        }
        var canceledAmountRatio: Float = .zero
        if canceledAmountDivisor != .zero && canceledAmountDividend != .zero {
            canceledAmountRatio = (canceledAmountDividend-canceledAmountDivisor)/canceledAmountDivisor
        }
        var canceledQuantityRatio: Float = .zero
        if canceledQuantityDivisor != .zero && canceledQuantityDividend != .zero {
            canceledQuantityRatio = (canceledQuantityDividend-canceledQuantityDivisor)/canceledQuantityDivisor
        }
        var returnAmountRatio: Float = .zero
        if returnAmountDivisor != .zero && returnAmountDividend != .zero {
            returnAmountRatio = (returnAmountDividend-returnAmountDivisor)/returnAmountDivisor
        }
        var returnQuantityRatio: Float = .zero
        if returnQuantityDivisor != .zero && returnQuantityDividend != .zero {
            returnQuantityRatio = (returnQuantityDividend-returnQuantityDivisor)/returnQuantityDivisor
        }

        let formatter = MyMindSaleReportRatioNumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = "▲"
        formatter.negativePrefix = "▼"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let numberFormatter = NumberFormatter {
            $0.numberStyle = .decimal
        }
        
        // TODO: Modify infoType
        let index = infoType.rawValue
        let yesterdayTitleString = itemType.getYesterdayTitleString(infoType: infoType)
        switch itemType {
        case .quantity:
            quantityTitleLabel.text = "數量"
            
            // 變動率
            let ratio = index == 0 ? saleQuantityRatio: index == 1 ? canceledQuantityRatio : returnQuantityRatio
            let string = formatter.string(from: NSNumber(value:ratio))
            if ratio == 0 {
                quantityRatioLabel.textColor = .prussianBlue
                quantityRatioLabel.backgroundColor = .prussianBlue.withAlphaComponent(0.2)
                quantityRatioLabel.text = "-"
            } else if ratio > 0 {
                quantityRatioLabel.textColor = .percentIncrease
                quantityRatioLabel.backgroundColor = .percentIncrease.withAlphaComponent(0.2)
                quantityRatioLabel.text = string
            } else {
                quantityRatioLabel.textColor = .vividRed
                quantityRatioLabel.backgroundColor = .vividRed.withAlphaComponent(0.2)
                quantityRatioLabel.text = string
            }
            
            // 今日數量
            var quantity = index == 0 ? saleQuantityDividend : index == 1 ? canceledQuantityDividend : returnQuantityDividend
            quantityLabel.text = numberFormatter.string(from: NSNumber(value: quantity))
            
            // 昨日銷售
            quantity = index == 0 ? saleQuantityDivisor : index == 1 ? canceledQuantityDivisor : returnQuantityDivisor
            yesterdayQuantityLabel.text = "\(yesterdayTitleString) "+(numberFormatter.string(from: NSNumber(value: quantity)) ?? "")
            
            // 轉單
            var value = index == 0 ? saleReports?.todayTransformedSaleReport?.saleQuantity : index == 1 ? saleReports?.todayTransformedSaleReport?.canceledQuantity : saleReports?.todayTransformedSaleReport?.returnQuantity
            transformedValueLabel.text = numberFormatter.string(from: NSNumber(value: value ?? 0))
            
            // 寄倉
            value = index == 0 ? saleReports?.todayShippedSaleReport?.saleQuantity : index == 1 ? saleReports?.todayShippedSaleReport?.canceledQuantity : saleReports?.todayShippedSaleReport?.returnQuantity
            shippedValueLabel.text = numberFormatter.string(from: NSNumber(value: value ?? 0))
            
        case .amount:
            quantityTitleLabel.text = "總額"
            let ratio = index == 0 ? saleAmountRatio: index == 1 ? canceledAmountRatio : returnAmountRatio
            let string = formatter.string(from: NSNumber(value:ratio))
            if ratio == 0 {
                quantityRatioLabel.textColor = .prussianBlue
                quantityRatioLabel.backgroundColor = .prussianBlue.withAlphaComponent(0.2)
                quantityRatioLabel.text = "-"
            } else if ratio > 0 {
                quantityRatioLabel.textColor = .percentIncrease
                quantityRatioLabel.backgroundColor = .percentIncrease.withAlphaComponent(0.2)
                quantityRatioLabel.text = string
            } else {
                quantityRatioLabel.textColor = .vividRed
                quantityRatioLabel.backgroundColor = .vividRed.withAlphaComponent(0.2)
                quantityRatioLabel.text = string
            }
            
            var quantity = index == 0 ? saleAmountDividend : index == 1 ? canceledAmountDividend : returnAmountDividend
            quantityLabel.attributedText = quantity.toDollarsString(dollarFont: .pingFangTCSemibold(ofSize: 14), dollarColor: .prussianBlue)
            
            quantity = index == 0 ? saleAmountDivisor : index == 1 ? canceledAmountDivisor : returnAmountDivisor
            yesterdayQuantityLabel.text = "\(yesterdayTitleString) " + (numberFormatter.string(from: NSNumber(value: quantity)) ?? "") + "元"
            
            var value = index == 0 ? saleReports?.todayTransformedSaleReport?.saleAmount : index == 1 ? saleReports?.todayTransformedSaleReport?.canceledAmount : saleReports?.todayTransformedSaleReport?.returnAmount
            let transformedValue = numberFormatter.string(from: NSNumber(value: value ?? 0))
            transformedValueLabel.text = "\(transformedValue ?? "0")元"
            
            value = index == 0 ? saleReports?.todayShippedSaleReport?.saleAmount : index == 1 ? saleReports?.todayShippedSaleReport?.canceledAmount : saleReports?.todayShippedSaleReport?.returnAmount
            let shippedValue = numberFormatter.string(from: NSNumber(value: value ?? 0))
            shippedValueLabel.text = "\(shippedValue ?? "0")元"
        }
    }
    
    private func activateConstraints() {
        activateConstraintsQuantityTitleLabel()
        activateConstraintsQuantityRatioLabel()
        activateConstraintsQuantityLabel()
        activateConstraintsYesterdayQuantityLabel()
        activateConstraintsSeperator()
        activateConstraintsTransformedTitleLabel()
        activateConstraintsTransformedValueLabel()
        activateConstraintsShippedTitleLabel()
        activateConstraintsShippedValueLabel()
    }
}
/// constraint
extension SaleReportInfoItemView {
    private func activateConstraintsQuantityTitleLabel() {
        let top = quantityTitleLabel.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = quantityTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let width = quantityTitleLabel.widthAnchor
            .constraint(equalToConstant: 54)
        let height = quantityTitleLabel.heightAnchor
            .constraint(equalToConstant: 24)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }
    
    private func activateConstraintsQuantityLabel() {
        let top = quantityLabel.topAnchor
            .constraint(equalTo: quantityTitleLabel.bottomAnchor, constant: 8)
        let leading = quantityLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let trailing = quantityLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -16)
        let height = quantityLabel.heightAnchor
            .constraint(equalToConstant: 33)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    
    private func activateConstraintsQuantityRatioLabel() {
        let top = quantityRatioLabel.topAnchor
            .constraint(equalTo: quantityLabel.bottomAnchor, constant: 4)
        let leading = quantityRatioLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let height = quantityRatioLabel.heightAnchor
            .constraint(equalToConstant: 18)
        let width = quantityRatioLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }
    
    private func activateConstraintsYesterdayQuantityLabel() {
        let top = yesterdayQuantityLabel.topAnchor
            .constraint(equalTo: quantityRatioLabel.bottomAnchor, constant: 8)
        let leading = yesterdayQuantityLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let trailing = yesterdayQuantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height = yesterdayQuantityLabel.heightAnchor
            .constraint(equalToConstant: 17)

        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsSeperator() {
        let top = seperator.topAnchor
            .constraint(equalTo: yesterdayQuantityLabel.bottomAnchor, constant: 7.5)
        let leading = seperator.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let trailing = seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        let height = seperator.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsTransformedTitleLabel() {
        let top = transformedTitleLabel.topAnchor
            .constraint(equalTo: seperator.bottomAnchor, constant: 7.5)
        let leading = transformedTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let height = transformedTitleLabel.heightAnchor
            .constraint(equalToConstant: 17)
        let width = transformedTitleLabel.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    private func activateConstraintsTransformedValueLabel() {
        let centerY = transformedValueLabel.centerYAnchor
            .constraint(equalTo: transformedTitleLabel.centerYAnchor)
        let leading = transformedValueLabel.leadingAnchor
            .constraint(equalTo: transformedTitleLabel.trailingAnchor)
        let trailing = transformedValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
    private func activateConstraintsShippedTitleLabel() {
        let top = shippedTitleLabel.topAnchor
            .constraint(equalTo: transformedTitleLabel.bottomAnchor, constant: 8)
        let leading = shippedTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let height = shippedTitleLabel.heightAnchor
            .constraint(equalToConstant: 17)
        let width = shippedTitleLabel.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    private func activateConstraintsShippedValueLabel() {
        let centerY = shippedValueLabel.centerYAnchor
            .constraint(equalTo: shippedTitleLabel.centerYAnchor)
        let leading = shippedValueLabel.leadingAnchor
            .constraint(equalTo: shippedTitleLabel.trailingAnchor)
        let trailing = shippedValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
}
