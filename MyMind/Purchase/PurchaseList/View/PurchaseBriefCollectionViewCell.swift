//
//  PurchaseBriefCollectionViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseBriefCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var backgroundBorderView: UIView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var trianlgeView: TriangleView!
    @IBOutlet private weak var purchaseNumberLabel: UILabel!
    @IBOutlet private weak var vendorNameLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var putInStorageDateLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundBorderView.layer.cornerRadius = 4
        backgroundBorderView.layer.borderWidth = 1
        backgroundBorderView.layer.borderColor = UIColor.mercury.cgColor
        configStatusLabel()
    }

    private func configStatusLabel() {
        statusLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        statusLabel.layer.cornerRadius = 4
        trianlgeView.fillColor = UIColor(hex: "10732a")
    }

    func config(with purchaseBrief: PurchaseBrief) {
        statusLabel.text = purchaseBrief.status.description
        let colorSet = colorForStatus(status: purchaseBrief.status)
        statusLabel.backgroundColor = colorSet.0
        trianlgeView.fillColor = colorSet.1
        purchaseNumberLabel.text = purchaseBrief.purchaseNumber
        vendorNameLabel.text = purchaseBrief.vendorName
        creatorLabel.text = purchaseBrief.creator
        createdDateLabel.text = purchaseBrief.createdDateString
        putInStorageDateLabel.text = purchaseBrief.expectStorageDateString
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        let value: Int = Int(purchaseBrief.totalAmount) ?? 0
        totalAmountLabel.text = formatter.string(from: value as NSNumber)
    }
}
extension PurchaseBriefCollectionViewCell: PurchaseStatusColorProvider { }
