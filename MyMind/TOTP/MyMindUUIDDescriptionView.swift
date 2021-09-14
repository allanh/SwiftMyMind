//
//  MyMindUUIDDescriptionView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class MyMindUUIDDescriptionView: NiblessView {
    private let backgroundView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "My Mind 買賣 OTP"
        $0.textColor = UIColor(hex: "1c4373")
        $0.font = .pingFangTCSemibold(ofSize: 16)
    }
    private let bullet1Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = .emperor
        $0.backgroundColor = .clear
        $0.text = "1."
    }
    private let description1Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "一個QR Code僅限綁定一支手機。"
        $0.textColor = .emperor
    }
    private let bullet2Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = .emperor
        $0.backgroundColor = .clear
        $0.text = "2."
    }
    private let description2Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "若刪除APP、清除資料、系統重設或系統升級，請到登入頁面右下角點選【重綁驗證碼】。"
        $0.textColor = .emperor
    }
    private let uuidLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "1c4373")
        $0.backgroundColor = .clear
        $0.numberOfLines = 0
        $0.textAlignment = .center
        var string = "App ID:"
        do {
            var uuid: String = try KeychainHelper.default.readItem(key: .uuid, valueType: String.self)
            uuid.removeLast(uuid.count-8)
            string += uuid
            $0.text = string
        } catch {}
    }
    private let uuidDescriptionLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = .emperor
        $0.backgroundColor = .clear
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "(此ID僅用於此裝置與帳號綁定之識別)"
    }
    private let seperator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e0")
    }
    @objc
    private func confirm() {
        removeFromSuperview()
    }
    let confirmButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("確定", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
        $0.setTitleColor(UIColor(hex: "1c4373"), for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        constructViewHierarchy()
        activateConstraints()
    }
    private func constructViewHierarchy() {
        addSubview(backgroundView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bullet1Label)
        contentView.addSubview(description1Label)
        contentView.addSubview(bullet2Label)
        contentView.addSubview(description2Label)
        contentView.addSubview(uuidLabel)
        contentView.addSubview(uuidDescriptionLabel)
        contentView.addSubview(seperator)
        contentView.addSubview(confirmButton)
        backgroundView.addSubview(contentView)
    }

    private func activateConstraints() {
        activateConstraintsBackgroundView()
        activateConstraintsContentView()
        activateConstraintsTitleLabel()
        activateConstraintsBullet1Label()
        activateConstraintsDescription1Label()
        activateConstraintsBullet2Label()
        activateConstraintsDescription2Label()
        activateConstraintsUUIDLabel()
        activateConstraintsUUIDDescriptionLabel()
        activateConstraintsSeperator()
        activateConstraintsConfirmButton()
    }
}
extension MyMindUUIDDescriptionView {
    private func activateConstraintsBackgroundView() {
        let centerX = backgroundView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let centerY = backgroundView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let width = backgroundView.widthAnchor.constraint(equalTo: widthAnchor)
        let height = backgroundView.heightAnchor.constraint(equalTo: heightAnchor)
        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }
    private func activateConstraintsContentView() {
        let centerY = contentView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        let trailing = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        let height = contentView.heightAnchor.constraint(equalToConstant: 260)
        NSLayoutConstraint.activate([
            leading, centerY, trailing, height
        ])
    }
    private func activateConstraintsTitleLabel() {
        let centerX = titleLabel.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
        let top = titleLabel.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 15)
         let height = titleLabel.heightAnchor.constraint(equalToConstant: 21)
        NSLayoutConstraint.activate([
            centerX, top, height
        ])
    }
    private func activateConstraintsBullet1Label() {
        let leading = bullet1Label.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let top = bullet1Label.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
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
            .constraint(equalTo: contentView.trailingAnchor, constant: -15)

        NSLayoutConstraint.activate([
            firstBaseLine, leading, trailing
        ])
    }
    private func activateConstraintsBullet2Label() {
        let leading = bullet2Label.leadingAnchor
            .constraint(equalTo: bullet1Label.leadingAnchor)
        let top = bullet2Label.topAnchor
            .constraint(equalTo: description1Label.bottomAnchor, constant: 10)
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
    private func activateConstraintsUUIDLabel() {
        let leading = uuidLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let trailing = uuidLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -15)
        let top = uuidLabel.topAnchor
            .constraint(equalTo: description2Label.bottomAnchor, constant: 10)

        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    private func activateConstraintsUUIDDescriptionLabel() {
        let leading = uuidDescriptionLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let trailing = uuidDescriptionLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -15)
        let top = uuidDescriptionLabel.topAnchor
            .constraint(equalTo: uuidLabel.bottomAnchor, constant: 4)

        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    private func activateConstraintsSeperator() {
        let top = seperator.topAnchor
            .constraint(equalTo: uuidDescriptionLabel.bottomAnchor, constant: 12)
        let leading = seperator.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let trailing = seperator.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -15)
        let height = seperator.heightAnchor
            .constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    private func activateConstraintsConfirmButton() {
        let centerX = confirmButton.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
        let width = confirmButton.widthAnchor
            .constraint(equalTo: contentView.widthAnchor)
        let height = confirmButton.heightAnchor
            .constraint(equalToConstant: 40)
        let bottom = confirmButton.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor, constant: -10)

        NSLayoutConstraint.activate([
            centerX, width, height, bottom
        ])
    }
}
