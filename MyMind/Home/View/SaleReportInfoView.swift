//
//  SaleReportInfoView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SaleReportInfoView: NiblessView {
    // 數據類型
    enum InfoType: Int {
        case sale = 0, canceled, sale_return
    }
    var hierarchyNotReady: Bool = true
    let saleReports: SaleReports?
    let type: InfoType
    init(frame: CGRect, saleReports: SaleReports?, type: InfoType) {
        self.saleReports = saleReports
        self.type = type
        super.init(frame: frame)
//        self.layer.cornerRadius = 8
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.tertiaryLabel.cgColor
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
    private var quantityView: SaleReportInfoItemView!
    private var amountView: SaleReportInfoItemView!
}
/// helper
extension SaleReportInfoView {
    private func constructViews() {
        quantityView = SaleReportInfoItemView(frame: bounds, saleReports: saleReports, type: type, itemType: .quantity)
        amountView = SaleReportInfoItemView(frame: bounds, saleReports: saleReports, type: type, itemType: .amount)
    }
    private func arrangeView() {
        addSubview(quantityView)
        addSubview(amountView)
    }
    private func activateConstraints() {
        activateConstraintsQuantityView()
        activateConstraintsAmountView()
    }
    func config(with today: SaleReport?, yesterday: SaleReport?, index: Int) {
        
    }
}
/// constraints
extension SaleReportInfoView {
    private func activateConstraintsQuantityView() {
        let top = quantityView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = quantityView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = quantityView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let width = quantityView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4617)

        NSLayoutConstraint.activate([
            top, bottom, leading, width
        ])
    }
    private func activateConstraintsAmountView() {
        let top = amountView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = amountView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = amountView.leadingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: 8)
        let trailing = amountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let width = amountView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4617)

        NSLayoutConstraint.activate([
            top, bottom, leading, trailing, width
        ])
    }
}
