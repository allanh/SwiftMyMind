//
//  MultiSelectableDropDownTableViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class MultiSelectableDropDownTableViewCell: UITableViewCell {
    let checkBoxButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "unchecked"), for: .normal)
        $0.setImage(UIImage(named: "checked"), for: .selected)
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTCRegular(ofSize: 14)
        label.textColor = UIColor(hex: "4c4c4c")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(titleLabel)
    }

    private func activateConstraints() {
        activateConstraintsCheckBoxButton()
        activateConstraintsTitleLabel()
    }
}
// MARK: - Layouts
extension MultiSelectableDropDownTableViewCell {
    private func activateConstraintsCheckBoxButton() {
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        let centerY = checkBoxButton.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = checkBoxButton.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let width = checkBoxButton.widthAnchor
            .constraint(equalToConstant: 20)
        let height = checkBoxButton.heightAnchor
            .constraint(equalTo: checkBoxButton.widthAnchor)

        NSLayoutConstraint.activate([
            centerY, leading, width, height
        ])
    }

    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: checkBoxButton.centerYAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: checkBoxButton.trailingAnchor, constant: 10)

        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }
}
