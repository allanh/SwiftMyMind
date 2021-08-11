//
//  PurchaseOrderInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseOrderInfoViewController: UIViewController {

    @IBOutlet private weak var purchaseIDLabel: UILabel!
    @IBOutlet private weak var vendorNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var expectStorageDateLabel: UILabel!
    @IBOutlet private weak var warehouseLabel: UILabel!
    @IBOutlet private weak var recipientNameLabel: UILabel!
    @IBOutlet private weak var recipientPhoneLabel: UILabel!
    @IBOutlet private weak var recipientAddressLabel: UILabel!
    @IBOutlet private weak var checkPurchasedProductsButton: UIButton!

    var purchaseOrder: PurchaseOrder?

    var didTapCheckPurchasedProductButton: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        configureStatusLabel()
        configureContentWithPurchaseOrder()
        checkPurchasedProductsButton.addTarget(self, action: #selector(checkPurchasedProductsButtonDidTapped(_:)), for: .touchUpInside)
    }

    private func configureRootView() {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
    }

    private func configureStatusLabel() {
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = 4
    }

    private func configureContentWithPurchaseOrder() {
        guard let order = purchaseOrder else { return }
        purchaseIDLabel.text = String(order.number)
        vendorNameLabel.text = order.vendorName

        statusLabel.text = order.status.description
        let color: UIColor = colorForStatus(status: order.status).0
        statusLabel.layer.borderColor = color.cgColor
        statusLabel.textColor = color

        expectStorageDateLabel.text = order.expectStorageDate
        warehouseLabel.text = order.expectStorageName

        recipientNameLabel.text = order.recipientInfo.name
        recipientPhoneLabel.text = order.recipientInfo.phone
        recipientAddressLabel.text = order.recipientInfo.address.fullAddressString

        checkPurchasedProductsButton.setTitle("共 \(order.productInfos.count) 件SKU", for: .normal)
    }

    @objc
    private func checkPurchasedProductsButtonDidTapped(_ sender: UIButton) {
        didTapCheckPurchasedProductButton?()
    }
}

extension PurchaseOrderInfoViewController: PurchaseStatusColorProvider { }
