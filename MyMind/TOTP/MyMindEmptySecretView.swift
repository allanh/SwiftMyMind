//
//  MyMindEmptySecretView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/21.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class MyMindEmptySecretView: NiblessView {
    // MARK: - Properties
    private let logoImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "scan")
    }

    private let noDataLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .brownGrey2
        $0.text = "目前還沒有任何資料⋯⋯"
    }

    private let scanLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = .brownGrey2
        $0.text = "按下右下角的相機\n開始掃描驗證 QR Code 吧！"
        $0.numberOfLines = 0
    }

    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(logoImageView)
        addSubview(noDataLabel)
        addSubview(scanLabel)
    }

    private func activateConstraints() {
        activateConstraintsIconImageView()
        activateConstraintsNoDataLabel()
        activateConstraintsScanLabel()
    }

    // MARK: - Layouts
    private func activateConstraintsIconImageView() {
        let centerX = logoImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let centerY = logoImageView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    private func activateConstraintsNoDataLabel() {
        let top = noDataLabel.topAnchor
            .constraint(equalTo: logoImageView.bottomAnchor, constant: 20)
        let leading = noDataLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 77)
        let height = noDataLabel.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }

    private func activateConstraintsScanLabel() {
        let leading = scanLabel.leadingAnchor
            .constraint(equalTo: noDataLabel.leadingAnchor)
        let top = scanLabel.topAnchor
            .constraint(equalTo: noDataLabel.bottomAnchor, constant: 8)

        NSLayoutConstraint.activate([
            leading, top
        ])
    }
}
