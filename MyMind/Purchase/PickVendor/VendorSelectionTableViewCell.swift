//
//  VendorSelectionTableViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class VendorSelectionTableViewCell: UITableViewCell {
    let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 16)
        $0.textColor = UIColor(hex: "4c4c4c")
    }

    let arrowImageView: UIImageView = UIImageView {
        $0.image = UIImage(named: "forward_arrow")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with vendorName: String) {
        titleLabel.text = vendorName
    }

    private func constructViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
    }

    private func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsArrowImageView()
    }

    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }

    private func activateConstraintsArrowImageView() {
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = arrowImageView.centerYAnchor
            .constraint(equalTo: titleLabel.centerYAnchor)
        let trailing = arrowImageView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)
        let width = arrowImageView.widthAnchor
            .constraint(equalToConstant: 25)
        let height = arrowImageView.heightAnchor
            .constraint(equalTo: arrowImageView.widthAnchor)

        NSLayoutConstraint.activate([
            centerY, trailing, height, width
        ])
    }
}
