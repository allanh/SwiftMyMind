//
//  MyMindInstructionView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class MyMindInstructionView: NiblessView {
    // MARK: - Properties
    private let logoImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "otp")
    }

    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 16)
        $0.textColor = UIColor(hex:"004477")
        $0.text = "My Mind 買賣 OTP"
        $0.textAlignment = .center
    }
    
    private let seperator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e0")
    }
    private let descriptionLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "1.\t請點選下方按鈕來掃描「My Mind買賣-登入OTP驗證綁定通知信」內的【驗證QR Code】。\n\n2.\t掃描成功後即綁定完成，會出現六位動態數字的驗證碼，並於每60秒更換一次。\n\n3.\t在My Mind買賣後台登入時，輸入這六位動態數字的驗證碼，即可完成登入。"
        $0.textColor = UIColor(hex: "545454")
    }

    let confirmButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("開始掃描", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.tintColor = .white
        $0.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.backgroundColor = UIColor(hex:"ff7d2c")
        $0.layer.cornerRadius = 10
    }

    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(seperator)
        addSubview(descriptionLabel)
        addSubview(confirmButton)
    }

    private func activateConstraints() {
        activateConstraintsIconImageView()
        activateConstraintsTitleLabel()
        activateConstraintsSeperator()
        activateConstraintsDescripyionLabel()
        activateConstraintsConfirmButton()
    }

    // MARK: - Layouts
    private func activateConstraintsIconImageView() {
        let centerX = logoImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = logoImageView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80)
        let width = logoImageView.widthAnchor.constraint(equalToConstant: 100)
        let height = logoImageView.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
    }
    private func activateConstraintsTitleLabel() {
        let centerX = titleLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = titleLabel.topAnchor
            .constraint(equalTo: logoImageView.bottomAnchor, constant: 30)
        let width = titleLabel.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 1 / 1.2)

        NSLayoutConstraint.activate([
            centerX, top, width
        ])
    }
    
    private func activateConstraintsSeperator() {
        let centerX = seperator.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = seperator.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
        let width = seperator.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 1 / 1.2)
        let height = seperator.heightAnchor
            .constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
    }

    private func activateConstraintsDescripyionLabel() {
        let centerX = descriptionLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = descriptionLabel.topAnchor
            .constraint(equalTo: seperator.bottomAnchor, constant: 12)
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
            .constraint(equalToConstant: 140)
        let height = confirmButton.heightAnchor
            .constraint(equalToConstant: 40)
        let bottom = confirmButton.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -20)

        NSLayoutConstraint.activate([
            centerX, width, height, bottom
        ])
    }

}