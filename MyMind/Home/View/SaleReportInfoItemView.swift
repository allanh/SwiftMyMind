//
//  SaleReportInfoItemView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class SaleReportInfoItemView: NiblessView {
    enum SaleReportInfoType {
        case quantity, amount
    }
    var hierarchyNotReady: Bool = true
    let saleReports: SaleReports?
    let index: Int
    let type: SaleReportInfoType
    init(frame: CGRect, saleReports: SaleReports?, index: Int, type: SaleReportInfoType) {
        self.saleReports = saleReports
        self.index = index
        self.type = type
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
        backgroundColor = .secondarySystemBackground
        hierarchyNotReady = false
    }
    private let quantityTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.font = .pingFangTCRegular(ofSize: 12)
    }
    private let quantityRatioLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 10)
    }
    private let quantityLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = .label
    }
    private let yesterdayQuantityLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = .label
    }
    private let seperator: DashedLineView = DashedLineView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    private let transformedTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.text = "轉單"
    }
    private let transformedValueLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = .label
    }
    private let shippedTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.text = "寄倉"
    }
    private let shippedValueLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = .label
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
        
        switch type {
        case .quantity:
            quantityTitleLabel.text = index == 0 ? "銷售數量" : index == 1 ? "取消數量" : "銷退數量"
            let ratio = index == 0 ? saleQuantityRatio: index == 1 ? canceledQuantityRatio : returnQuantityRatio
            let string = formatter.string(from: NSNumber(value:ratio))
            if ratio >= 0 {
                quantityRatioLabel.textColor = .systemGreen
            } else {
                quantityRatioLabel.textColor = .systemRed
            }
            quantityRatioLabel.text = (ratio == 0) ? "--" : string
            var quantity = index == 0 ? saleQuantityDividend : index == 1 ? canceledQuantityDividend : returnQuantityDividend
            quantityLabel.text = numberFormatter.string(from: NSNumber(value: quantity))
            quantity = index == 0 ? saleQuantityDivisor : index == 1 ? canceledQuantityDivisor : returnQuantityDivisor
            yesterdayQuantityLabel.text = "昨日數量 "+(numberFormatter.string(from: NSNumber(value: quantity)) ?? "")
            
            var value = index == 0 ? saleReports?.todayTransformedSaleReport?.saleQuantity : index == 1 ? saleReports?.todayTransformedSaleReport?.canceledQuantity : saleReports?.todayTransformedSaleReport?.returnQuantity
            transformedValueLabel.text = numberFormatter.string(from: NSNumber(value: value ?? 0))
            value = index == 0 ? saleReports?.todayShippedSaleReport?.saleQuantity : index == 1 ? saleReports?.todayShippedSaleReport?.canceledQuantity : saleReports?.todayShippedSaleReport?.returnQuantity
            shippedValueLabel.text = numberFormatter.string(from: NSNumber(value: value ?? 0))
        case .amount:
            quantityTitleLabel.text = index == 0 ? "銷售總額" : index == 1 ? "取消總額" : "銷退總額"
            let ratio = index == 0 ? saleAmountRatio: index == 1 ? canceledAmountRatio : returnAmountRatio
            let string = formatter.string(from: NSNumber(value:ratio))
            if ratio >= 0 {
                quantityRatioLabel.textColor = .systemGreen
            } else {
                quantityRatioLabel.textColor = .systemRed
            }
            quantityRatioLabel.text = (ratio == 0) ? "--" : string
            var quantity = index == 0 ? saleAmountDividend : index == 1 ? canceledAmountDividend : returnAmountDividend
            quantityLabel.text = numberFormatter.string(from: NSNumber(value: quantity))
            quantity = index == 0 ? saleAmountDivisor : index == 1 ? canceledAmountDivisor : returnAmountDivisor
            yesterdayQuantityLabel.text = "昨日總額 "+(numberFormatter.string(from: NSNumber(value: quantity)) ?? "")
            var value = index == 0 ? saleReports?.todayTransformedSaleReport?.saleAmount : index == 1 ? saleReports?.todayTransformedSaleReport?.canceledAmount : saleReports?.todayTransformedSaleReport?.returnAmount
            transformedValueLabel.text = numberFormatter.string(from: NSNumber(value: value ?? 0))
            value = index == 0 ? saleReports?.todayShippedSaleReport?.saleAmount : index == 1 ? saleReports?.todayShippedSaleReport?.canceledAmount : saleReports?.todayShippedSaleReport?.returnAmount
            shippedValueLabel.text = numberFormatter.string(from: NSNumber(value: value ?? 0))
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
            .constraint(equalTo: topAnchor, constant: 8)
        let leading = quantityTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let height = quantityTitleLabel.heightAnchor
            .constraint(equalToConstant: 17)

        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    private func activateConstraintsQuantityRatioLabel() {
        let centerY = quantityRatioLabel.centerYAnchor
            .constraint(equalTo: quantityTitleLabel.centerYAnchor)
        let leading = quantityRatioLabel.leadingAnchor
            .constraint(equalTo: quantityTitleLabel.trailingAnchor, constant: 4)
        let height = quantityRatioLabel.heightAnchor
            .constraint(equalToConstant: 17)

        NSLayoutConstraint.activate([
            centerY, leading, height
        ])
    }
    private func activateConstraintsQuantityLabel() {
        let top = quantityLabel.topAnchor
            .constraint(equalTo: quantityTitleLabel.bottomAnchor, constant: 8)
        let leading = quantityLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let height = quantityLabel.heightAnchor
            .constraint(equalToConstant: 24)

        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsYesterdayQuantityLabel() {
        let top = yesterdayQuantityLabel.topAnchor
            .constraint(equalTo: quantityLabel.bottomAnchor, constant: 8)
        let leading = yesterdayQuantityLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = yesterdayQuantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let height = yesterdayQuantityLabel.heightAnchor
            .constraint(equalToConstant: 17)

        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsSeperator() {
        let top = seperator.topAnchor
            .constraint(equalTo: yesterdayQuantityLabel.bottomAnchor, constant: 8)
        let leading = seperator.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let height = seperator.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsTransformedTitleLabel() {
        let top = transformedTitleLabel.topAnchor
            .constraint(equalTo: seperator.bottomAnchor, constant: 8)
        let leading = transformedTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let height = transformedTitleLabel.heightAnchor
            .constraint(equalToConstant: 16)
        let width = transformedTitleLabel.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    private func activateConstraintsTransformedValueLabel() {
        let centerY = transformedValueLabel.centerYAnchor
            .constraint(equalTo: transformedTitleLabel.centerYAnchor)
        let leading = transformedValueLabel.leadingAnchor
            .constraint(equalTo: transformedTitleLabel.trailingAnchor, constant: 8)
        let trailing = transformedValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
    private func activateConstraintsShippedTitleLabel() {
        let top = shippedTitleLabel.topAnchor
            .constraint(equalTo: transformedTitleLabel.bottomAnchor, constant: 8)
        let leading = shippedTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let height = shippedTitleLabel.heightAnchor
            .constraint(equalToConstant: 16)
        let width = shippedTitleLabel.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    private func activateConstraintsShippedValueLabel() {
        let centerY = shippedValueLabel.centerYAnchor
            .constraint(equalTo: shippedTitleLabel.centerYAnchor)
        let leading = shippedValueLabel.leadingAnchor
            .constraint(equalTo: shippedTitleLabel.trailingAnchor, constant: 8)
        let trailing = shippedValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
}
