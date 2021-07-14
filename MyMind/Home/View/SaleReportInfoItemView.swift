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
    let reportOfToday: SaleReport?
    let reportOfYesterday: SaleReport?
    let transformed: SaleReport?
    let shipped: SaleReport?
    let index: Int
    let type: SaleReportInfoType
    init(frame: CGRect, today: SaleReport?, yesterday: SaleReport?, transformed: SaleReport?, shipped: SaleReport?, index: Int, type: SaleReportInfoType) {
        self.reportOfToday = today
        self.reportOfYesterday = yesterday
        self.transformed = transformed
        self.shipped = shipped
        self.index = index
        self.type = type
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
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
    private let seperator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .label
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
        var saleAmountRatio: Float = 0
        if let todaySaleAmount = reportOfToday?.saleAmount, let yesterdaySaleAmount = reportOfYesterday?.saleAmount {
            saleAmountRatio = (todaySaleAmount - yesterdaySaleAmount) / yesterdaySaleAmount
        }
        var saleQuantityRatio: Float = 0
        if let todaySaleQuantity = reportOfToday?.saleQuantity, let yesterdaySaleQuantity = reportOfYesterday?.saleQuantity {
            saleQuantityRatio = Float((todaySaleQuantity - yesterdaySaleQuantity) / yesterdaySaleQuantity)
        }
        var canceledAmountRatio: Float = 0
        if let todayCanceledAmount = reportOfToday?.canceledAmount, let yesterdayCanceledAmount = reportOfYesterday?.canceledAmount {
            canceledAmountRatio = (todayCanceledAmount - yesterdayCanceledAmount) / yesterdayCanceledAmount
        }
        var canceledQuantityRatio: Float = 0
        if let todayCanceledQuantity = reportOfToday?.canceledQuantity, let yesterdayCanceledQuantity = reportOfYesterday?.canceledQuantity {
            canceledQuantityRatio = Float((todayCanceledQuantity - yesterdayCanceledQuantity) / yesterdayCanceledQuantity)
        }
        var returnAmountRatio: Float = 0
        if let todayReturnAmount = reportOfToday?.returnAmount, let yesterdayReturnAmount = reportOfYesterday?.returnAmount {
            returnAmountRatio = (todayReturnAmount - yesterdayReturnAmount) / yesterdayReturnAmount
        }
        var returnQuantityRatio: Float = 0
        if let todayReturnQuantity = reportOfToday?.returnQuantity, let yesterdayReturnQuantity = reportOfYesterday?.returnQuantity {
            returnQuantityRatio = Float((todayReturnQuantity - yesterdayReturnQuantity) / yesterdayReturnQuantity)
        }

        let formatter = MyMindSaleReportRatioNumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = "▲"
        formatter.negativePrefix = "▼"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        switch type {
        case .quantity:
            quantityTitleLabel.text = index == 0 ? "銷售數量" : index == 1 ? "取消數量" : "銷退數量"
            let ratio = index == 0 ? saleQuantityRatio: index == 1 ? canceledQuantityRatio : returnQuantityRatio
            let value = formatter.string(from: NSNumber(value:ratio))
            if ratio >= 0 {
                quantityRatioLabel.textColor = .systemGreen
            } else {
                quantityRatioLabel.textColor = .systemRed
            }
            quantityRatioLabel.text = value
            quantityLabel.text = index == 0 ? "\(reportOfToday?.saleQuantity ?? 0)" : index == 1 ? "\(reportOfToday?.canceledQuantity ?? 0)" : "\(reportOfToday?.returnQuantity ?? 0)"
            yesterdayQuantityLabel.text = index == 0 ? "昨日數量 \(reportOfYesterday?.saleQuantity ?? 0)" : index == 1 ? "昨日數量 \(reportOfYesterday?.canceledQuantity ?? 0)" : "昨日數量 \(reportOfYesterday?.returnQuantity ?? 0)"
            transformedValueLabel.text = index == 0 ? "\(transformed?.saleQuantity ?? 0)" : index == 1 ? "\(transformed?.canceledQuantity ?? 0)" : "\(transformed?.returnQuantity ?? 0)"
            shippedValueLabel.text = index == 0 ? "\(shipped?.saleQuantity ?? 0)" : index == 1 ? "\(shipped?.canceledQuantity ?? 0)" : "\(shipped?.returnQuantity ?? 0)"
        case .amount:
            quantityTitleLabel.text = index == 0 ? "銷售總額" : index == 1 ? "取消總額" : "銷退總額"
            let ratio = index == 0 ? saleAmountRatio: index == 1 ? canceledAmountRatio : returnAmountRatio
            let value = formatter.string(from: NSNumber(value:ratio))
            if ratio >= 0 {
                quantityRatioLabel.textColor = .systemGreen
            } else {
                quantityRatioLabel.textColor = .systemRed
            }
            quantityRatioLabel.text = (ratio > 0) ? "▲ \(ratio) %" : (ratio == 0) ? value : "▼ \(ratio) %"
            quantityLabel.text = index == 0 ? "\(reportOfToday?.saleAmount ?? 0)" : index == 1 ? "\(reportOfToday?.canceledAmount ?? 0)" : "\(reportOfToday?.returnAmount ?? 0)"
            yesterdayQuantityLabel.text = index == 0 ? "昨日總額 \(reportOfYesterday?.saleAmount ?? 0)" : index == 1 ? "昨日總額 \(reportOfYesterday?.canceledAmount ?? 0)" : "昨日總額 \(reportOfYesterday?.returnAmount ?? 0)"
            transformedValueLabel.text = index == 0 ? "\(transformed?.saleAmount ?? 0)" : index == 1 ? "\(transformed?.canceledAmount ?? 0)" : "\(transformed?.returnAmount ?? 0)"
            shippedValueLabel.text = index == 0 ? "\(shipped?.saleAmount ?? 0)" : index == 1 ? "\(shipped?.canceledAmount ?? 0)" : "\(shipped?.returnAmount ?? 0)"
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
        let trailing = quantityRatioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        let height = quantityRatioLabel.heightAnchor
            .constraint(equalToConstant: 17)

        NSLayoutConstraint.activate([
            centerY, leading, height, trailing
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
