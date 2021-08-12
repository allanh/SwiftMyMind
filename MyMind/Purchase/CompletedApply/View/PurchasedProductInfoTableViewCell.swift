//
//  PurchasedProductInfoTableViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import Kingfisher

class PurchasedProductInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var originalNumberLabel: UILabel!
    @IBOutlet private weak var purchaseCostLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var boxQuantityLabel: UILabel!
    @IBOutlet private weak var totalCostLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImageView.layer.borderWidth = 1
        productImageView.layer.borderColor = UIColor(hex: "cccccc").cgColor
        productImageView.layer.cornerRadius = 4

        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hex: "cccccc").cgColor
        containerView.layer.cornerRadius = 4    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
    }

    func configure(with productInfo: PurchaseOrder.ProductInfo) {
        if let imageURLString = productInfo.imageInfos.first?.url,
           let url = URL(string: imageURLString) {
            productImageView.kf.setImage(with: url)
        }
        let formatter: NumberFormatter = NumberFormatter {
            $0.numberStyle = .currency
            $0.currencySymbol = ""
        }
        nameLabel.text = productInfo.name
        numberLabel.text = productInfo.number
        originalNumberLabel.text = productInfo.originalProductNumber
        purchaseCostLabel.text =  formatter.string(from: NSNumber(value: productInfo.purchaseCost))
        quantityLabel.text = "\(productInfo.purchaseQuantity) \(productInfo.stockUnitName)"
        boxQuantityLabel.text = "(=\(productInfo.purchaseBoxQuantity)\(productInfo.boxStockUnitName))"
        totalCostLabel.text = formatter.string(from: NSNumber(value: productInfo.totalPrice ?? 0))
    }
}
