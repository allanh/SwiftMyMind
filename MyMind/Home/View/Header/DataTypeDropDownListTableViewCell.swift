//
//  DataTypeDropDownListTableViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/16.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class DataTypeDropDownListTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTCSemibold(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initPhase2()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPhase2()
    }

    private func initPhase2() {
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
