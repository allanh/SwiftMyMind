//
//  ApplyPurchaseInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class ApplyPurchaseInfoViewController: UIViewController {

    @IBOutlet private weak var vendorNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var expectStorageDateTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var warehouseTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var recipientNameLabel: UILabel!
    @IBOutlet private weak var recipientPhoneLabel: UILabel!
    @IBOutlet private weak var recipientAddressLabel: UILabel!
    @IBOutlet private weak var checkPurchasedProductsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configTextFields()
        // Do any additional setup after loading the view.
    }

    private func configTextFields() {
        [expectStorageDateTextField, warehouseTextField].forEach {
            guard let textField = $0 else { return }
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.separator.cgColor
            textField.layer.cornerRadius = 4
            textField.setLeftPaddingPoints(10)
            textField.font = .pingFangTCRegular(ofSize: 14)
            textField.textColor = UIColor(hex: "4c4c4c")

            let imageName: String = textField == expectStorageDateTextField ? "calendar_icon" : "search"

            configRightIconForTextField(textField, imageName: imageName)
        }
    }

    private func configRightIconForTextField(_ textField: UITextField, imageName: String) {
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        expectStorageDateTextField.rightView = containerView
    }

}
