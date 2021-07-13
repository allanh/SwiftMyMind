//
//  SaleReportInfoView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SaleReportInfoView: NiblessView {
    var hierarchyNotReady: Bool = true
    let reportOfToday: SaleReport?
    let reportOfYesterday: SaleReport?
    let transformed: SaleReport?
    let shipped: SaleReport?
    let index: Int
    init(frame: CGRect, today: SaleReport?, yesterday: SaleReport?, transformed: SaleReport?, shipped: SaleReport?, index: Int) {
        self.index = index
        self.reportOfToday = today
        self.reportOfYesterday = yesterday
        self.transformed = transformed
        self.shipped = shipped
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.tertiaryLabel.cgColor
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        constructViews()
        arrangeView()
        activateConstraints()
        backgroundColor = .systemBackground
        hierarchyNotReady = false
    }
    private var headerView: IndicatorHeaderView!
    private var quantityView: SaleReportInfoItemView!
    private var amountView: SaleReportInfoItemView!
}
/// helper
extension SaleReportInfoView {
    private func constructViews() {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        headerView = IndicatorHeaderView(frame: bounds, indicatorWidth: 6, title: index == 0 ? "今日銷售數據": index == 1 ? "今日取消數據": "今日銷退數據", alternativeInfo: formatter.string(from: Date()))
        quantityView = SaleReportInfoItemView(frame: bounds, today: reportOfToday, yesterday: reportOfYesterday, transformed: transformed, shipped: shipped, index: index, type: .quantity)
        amountView = SaleReportInfoItemView(frame: bounds, today: reportOfToday, yesterday: reportOfYesterday, transformed: transformed, shipped: shipped, index: index, type: .amount)
    }
    private func arrangeView() {
        addSubview(headerView)
        addSubview(quantityView)
        addSubview(amountView)
    }
    private func activateConstraints() {
        activateConstraintsHeaderView()
        activateConstraintsQuantityView()
        activateConstraintsAmountView()
    }
    func config(with today: SaleReport?, yesterday: SaleReport?, index: Int) {
        
    }
}
/// constraints
extension SaleReportInfoView {
    private func activateConstraintsHeaderView() {
        let top = headerView.topAnchor
            .constraint(equalTo: topAnchor, constant: 8)
        let height = headerView.heightAnchor
            .constraint(equalToConstant: 56)
        let leading = headerView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = headerView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            top, height, leading, trailing
        ])
    }
    private func activateConstraintsQuantityView() {
        let top = quantityView.topAnchor
            .constraint(equalTo: headerView.bottomAnchor, constant: 16)
        let bottom = quantityView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -16)
        let leading = quantityView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let width = quantityView.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 0.45)

        NSLayoutConstraint.activate([
            top, bottom, leading, width
        ])
    }
    private func activateConstraintsAmountView() {
        let top = amountView.topAnchor
            .constraint(equalTo: headerView.bottomAnchor, constant: 16)
        let bottom = amountView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -16)
        let trailing = amountView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -8)
        let width = amountView.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 0.45)

        NSLayoutConstraint.activate([
            top, bottom, trailing, width
        ])
    }
}
