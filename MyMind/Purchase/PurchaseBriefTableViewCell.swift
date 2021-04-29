//
//  PurchaseBriefTableViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseBriefTableViewCell: UITableViewCell {
    // MARK: - Properties
    let titleLabel: UILabel = UILabel {
        $0.textColor = .black
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    let createdDateLabel: UILabel = UILabel {
        $0.textColor = UIColor(hex: "b4b4b4")
        $0.font = .pingFangTCRegular(ofSize: 12)
    }

    let statusLabel: UILabel = UILabel {
        $0.textAlignment = .center
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.green.cgColor
        $0.textColor = .green
    }
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constructViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(createdDateLabel)
        contentView.addSubview(statusLabel)
    }

    func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsCreatedDateLabel()
        activateConstraintsStatusLabel()
    }

    func config(with purchaseBrief: PurchaseBrief) {
        titleLabel.text = purchaseBrief.vendorName
        createdDateLabel.text = purchaseBrief.createdDateString
        configStatusLabel(with: purchaseBrief.status)
    }

    private func configStatusLabel(with status: PurchaseStatus) {
        statusLabel.text = status.description
        var color: UIColor = .black
        switch status {
        case .approved, .closed, .purchasing: color = .green
        case .review, .putInStorage, .pending: color = .orange
        case .rejected, .void, .revoked, .unusual: color = .red
        }
        statusLabel.layer.borderColor = color.cgColor
        statusLabel.textColor = color
    }
}
// MARK: - Layouts
extension PurchaseBriefTableViewCell {
    func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 10)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 30)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    func activateConstraintsCreatedDateLabel() {
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = createdDateLabel.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 3)
        let leading = createdDateLabel.leadingAnchor
            .constraint(equalTo: titleLabel.leadingAnchor)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    func activateConstraintsStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = statusLabel.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let trailing = statusLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)
        let width = statusLabel.widthAnchor
            .constraint(equalToConstant: 75)
        let height = statusLabel.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            centerY, trailing, width, height
        ])
    }
}
