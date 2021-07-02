//
//  PurchaseBriefReviewingCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseBriefReviewingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var backgroundBorderView: UIView!
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
        backgroundBorderView.layer.borderColor = UIColor(hex: "e5e5e5").cgColor
    }

    func config(with purchaseBrief: PurchaseBrief) {
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
