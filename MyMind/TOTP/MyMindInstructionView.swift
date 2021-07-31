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
    private let bullet1Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.text = "1."
    }
    private let description1Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "請點選下方「開始掃描」按鈕來掃描「帳號綁定 OTP 驗證通知信」內的【驗證 QR Code】"
        $0.textColor = UIColor(hex: "545454")
    }
    private let bullet2Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.text = "2."
    }
    private let description2Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "掃描成功後即綁定完成，會出現六位數字的動態驗證碼，並於每 60 秒更換一次。"
        $0.textColor = UIColor(hex: "545454")
    }
    private let bullet3Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.text = "3."
    }
    private let description3Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "在 My Mind 買賣後台登入時，輸入這六位數字的動態驗證碼，即可完成登入。"
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
        self.layer.cornerRadius = 10
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(seperator)
        addSubview(bullet1Label)
        addSubview(description1Label)
        addSubview(bullet2Label)
        addSubview(description2Label)
        addSubview(bullet3Label)
        addSubview(description3Label)
        addSubview(confirmButton)
    }

    private func activateConstraints() {
        activateConstraintsIconImageView()
        activateConstraintsTitleLabel()
        activateConstraintsSeperator()
        activateConstraintsBullet1Label()
        activateConstraintsDescription1Label()
        activateConstraintsBullet2Label()
        activateConstraintsDescription2Label()
        activateConstraintsBullet3Label()
        activateConstraintsDescription3Label()
        activateConstraintsConfirmButton()
    }

    // MARK: - Layouts
    private func activateConstraintsIconImageView() {
        let centerX = logoImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let top = logoImageView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25)
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
    private func activateConstraintsBullet1Label() {
        let leading = bullet1Label.leadingAnchor
            .constraint(equalTo: seperator.leadingAnchor)
        let top = bullet1Label.topAnchor
            .constraint(equalTo: seperator.bottomAnchor, constant: 12)
        let width = bullet1Label.widthAnchor
            .constraint(equalToConstant: 15)

        NSLayoutConstraint.activate([
            leading, top, width
        ])
    }

    private func activateConstraintsDescription1Label() {
        let firstBaseLine = description1Label.firstBaselineAnchor
            .constraint(equalTo: bullet1Label.firstBaselineAnchor)
        let leading = description1Label.leadingAnchor
            .constraint(equalTo: bullet1Label.trailingAnchor)
        let trailing = description1Label.trailingAnchor
            .constraint(equalTo: seperator.trailingAnchor)

        NSLayoutConstraint.activate([
            firstBaseLine, leading, trailing
        ])
    }
    private func activateConstraintsBullet2Label() {
        let leading = bullet2Label.leadingAnchor
            .constraint(equalTo: bullet1Label.leadingAnchor)
        let top = bullet2Label.topAnchor
            .constraint(equalTo: description1Label.bottomAnchor, constant: 20)
        let width = bullet2Label.widthAnchor
            .constraint(equalToConstant: 15)

        NSLayoutConstraint.activate([
            leading, top, width
        ])
    }

    private func activateConstraintsDescription2Label() {
        let firstBaseLine = description2Label.firstBaselineAnchor
            .constraint(equalTo: bullet2Label.firstBaselineAnchor)
        let leading = description2Label.leadingAnchor
            .constraint(equalTo: bullet2Label.trailingAnchor)
        let trailing = description2Label.trailingAnchor
            .constraint(equalTo: description1Label.trailingAnchor)

        NSLayoutConstraint.activate([
            firstBaseLine, leading, trailing
        ])
    }
    private func activateConstraintsBullet3Label() {
        let leading = bullet3Label.leadingAnchor
            .constraint(equalTo: bullet2Label.leadingAnchor)
        let top = bullet3Label.topAnchor
            .constraint(equalTo: description2Label.bottomAnchor, constant: 20)
        let width = bullet3Label.widthAnchor
            .constraint(equalToConstant: 15)

        NSLayoutConstraint.activate([
            leading, top, width
        ])
    }

    private func activateConstraintsDescription3Label() {
        let firstBaseLine = description3Label.firstBaselineAnchor
            .constraint(equalTo: bullet3Label.firstBaselineAnchor)
        let leading = description3Label.leadingAnchor
            .constraint(equalTo: bullet3Label.trailingAnchor)
        let trailing = description3Label.trailingAnchor
            .constraint(equalTo: description2Label.trailingAnchor)

        NSLayoutConstraint.activate([
            firstBaseLine, leading, trailing
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

