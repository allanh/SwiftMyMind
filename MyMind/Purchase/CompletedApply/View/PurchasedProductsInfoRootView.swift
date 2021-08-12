//
//  PurchasedProductsInfoRootView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class PurchasedProductsInfoRootView: NiblessView {
    private var hierarchyNotReady = true
    let tableView: UITableView = UITableView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let seperator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "797979")
    }
    private let summaryLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "434343")
        $0.font = .pingFangTCSemibold(ofSize: 16)
    }
    private let costTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "7f7f7f")
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "未稅 $"
    }
    private let costLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "7f7f7f")
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
    }
    private let taxTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "7f7f7f")
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "稅額 $"
    }
    private let taxLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "7f7f7f")
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
    }
   private let totalTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "3758a8")
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "合計(含稅) $"
    }
    private let totalLabel: UILabel = UILabel {
         $0.translatesAutoresizingMaskIntoConstraints = false
         $0.textColor = UIColor(hex: "3758a8")
         $0.font = .pingFangTCSemibold(ofSize: 14)
         $0.textAlignment = .right
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        constructViewHierarchy()
        activateConstraints()
        backgroundColor = .white
        hierarchyNotReady = false
    }
    private func constructViewHierarchy() {
        addSubview(tableView)
        addSubview(seperator)
        addSubview(summaryLabel)
        addSubview(costTitleLabel)
        addSubview(costLabel)
        addSubview(taxTitleLabel)
        addSubview(taxLabel)
        addSubview(totalTitleLabel)
        addSubview(totalLabel)
    }
    private func activateConstraints() {
        activateConstraintsTableView()
        activateConstraintsSeperator()
        activateConstraintsSummaryLabel()
        activateConstraintsCostTitleLabel()
        activateConstraintsCostLabel()
        activateConstraintsTaxTitleLabel()
        activateConstraintsTaxLabel()
        activateConstraintsTotalTitleLabel()
        activateConstraintsTotalLabel()
    }
    func config(with itemCount: Int, totalCost: Float) {
        summaryLabel.text = "共 \(itemCount) 件SKU"
        let formatter: NumberFormatter = NumberFormatter {
            $0.numberStyle = .currency
            $0.currencySymbol = ""
        }
        costLabel.text = formatter.string(from: NSNumber(value: totalCost))
        let tax = totalCost * 0.05
        taxLabel.text = formatter.string(from: NSNumber(value: tax))
        totalLabel.text = formatter.string(from: NSNumber(value: totalCost+tax))
    }
    private func activateConstraintsTableView() {
        let top = tableView.topAnchor.constraint(equalTo: topAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }
    private func activateConstraintsSeperator() {
        let top = seperator.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        let leading = seperator.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = seperator.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height = seperator.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    private func activateConstraintsSummaryLabel() {
        let top = summaryLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8)
        let leading = summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        let centerY = summaryLabel.centerYAnchor.constraint(equalTo: costTitleLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            top, leading, centerY
        ])
    }
    private func activateConstraintsCostTitleLabel() {
        let trailing = costTitleLabel.trailingAnchor.constraint(equalTo: taxTitleLabel.trailingAnchor)
        let leading = costTitleLabel.leadingAnchor.constraint(equalTo: taxTitleLabel.leadingAnchor)
        let centerY = costTitleLabel.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            trailing, leading, centerY
        ])
    }
    private func activateConstraintsCostLabel() {
        let trailing = costLabel.trailingAnchor.constraint(equalTo: taxLabel.trailingAnchor)
        let leading = costLabel.leadingAnchor.constraint(equalTo: taxLabel.leadingAnchor)
        let bottom = costLabel.bottomAnchor.constraint(equalTo: taxLabel.topAnchor, constant: -8)
        NSLayoutConstraint.activate([
            trailing, leading, bottom
        ])
    }
    private func activateConstraintsTaxTitleLabel() {
        let trailing = taxTitleLabel.trailingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor)
        let leading = taxTitleLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.leadingAnchor)
        let centerY = taxTitleLabel.centerYAnchor.constraint(equalTo: taxLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            trailing, leading, centerY
        ])
    }
    private func activateConstraintsTaxLabel() {
        let trailing = taxLabel.trailingAnchor.constraint(equalTo: totalLabel.trailingAnchor)
        let leading = taxLabel.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor)
        let bottom = taxLabel.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -8)
        NSLayoutConstraint.activate([
            trailing, leading, bottom
        ])
    }
    private func activateConstraintsTotalTitleLabel() {
        let centerY = totalTitleLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            centerY
        ])
    }
    private func activateConstraintsTotalLabel() {
        let trailing = totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        let leading = totalLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor, constant: 8)
        let bottom = totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        NSLayoutConstraint.activate([
            trailing, leading, bottom
        ])
    }

}
