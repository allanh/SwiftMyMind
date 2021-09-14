//
//  SingleLabelTableViewCell.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SingleLabelTableViewCell: UITableViewCell {

    let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .veryDarkGray
    }

    private var viewHierarchyNotReady: Bool = true

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard viewHierarchyNotReady else { return }
        constructViewHierarchy()
        activateConstraints()
        viewHierarchyNotReady = false
    }

    private func constructViewHierarchy() {
        contentView.addSubview(titleLabel)
    }

    private func activateConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)

        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }
}
