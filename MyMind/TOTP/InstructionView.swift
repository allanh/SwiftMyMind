//
//  InstructionView.swift
//  UDIAuthorizer
//
//  Created by Barry Chen on 2021/1/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class InstructionView: NiblessView {
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "launch_icon")
        imageView.image = image
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pingFangTCRegular(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "1.\t在「udn買東西綜合電商-登入驗證APP發送通知信」中，會包含一張 QR 碼。\n2.\t請利用本程式掃描該 QR 碼取得動態驗證碼。\n3.\t如有問題請洽詢 udn買東西廠商服務組。"
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        } else {
            label.textColor = UIColor(hex: "3c3c43").withAlphaComponent(0.6)
        }
        return label
    }()

    let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("我知道了", for: .normal)
        button.titleLabel?.font = .pingFangTCSemibold(ofSize: 20)
        button.setTitleColor(.systemOrange, for: .normal)
        return button
    }()

    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(logoImageView)
        addSubview(descriptionLabel)
        addSubview(confirmButton)
    }

    private func activateConstraints() {
        activateConstraintsIconImageView()
        activateConstraintsDescripyionLabel()
        activateConstraintsConfirmButton()
    }

    // MARK: - Layouts
    private func activateConstraintsIconImageView() {
        let centerX = logoImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = logoImageView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80)
        let width = logoImageView.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 1 / 1.5)
        let height = logoImageView.heightAnchor
            .constraint(equalTo: logoImageView.widthAnchor)

        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
    }

    private func activateConstraintsDescripyionLabel() {
        let centerX = descriptionLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = descriptionLabel.topAnchor
            .constraint(equalTo: logoImageView.bottomAnchor, constant: 30)
        let width = descriptionLabel.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 1 / 1.2)

        NSLayoutConstraint.activate([
            centerX, top, width
        ])
    }

    private func activateConstraintsConfirmButton() {
        let centerX = confirmButton.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let width = confirmButton.widthAnchor
            .constraint(equalTo: widthAnchor, constant: 200)
        let height = confirmButton.heightAnchor
            .constraint(equalToConstant: 40)
        let bottom = confirmButton.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -20)

        NSLayoutConstraint.activate([
            centerX, width, height, bottom
        ])
    }
}
