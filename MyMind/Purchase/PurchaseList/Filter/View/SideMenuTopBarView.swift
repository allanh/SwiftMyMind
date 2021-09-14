//
//  SideMenuTopBarView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SideMenuTopBarView: NiblessView {
    // MARK: - Properties
    private let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = .prussianBlue
        $0.text = "篩選條件"
    }

    private let closeButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "close"), for: .normal)
    }

    private let separatorView: UIView = UIView {
        $0.backgroundColor = .separator
    }
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
    }

    func constructViewHierarchy() {
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(separatorView)
    }

    func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsCloseButton()
        activateConstraintsSeparatorView()
    }
}
// MARK: - Layouts
extension SideMenuTopBarView {
    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 15)
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)

        NSLayoutConstraint.activate([
            leading, centerY
        ])
    }

    private func activateConstraintsCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let trailing = closeButton.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -15)
        let centerY = closeButton.centerYAnchor
            .constraint(equalTo: centerYAnchor)

        NSLayoutConstraint.activate([
            trailing, centerY
        ])
    }

    private func activateConstraintsSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        let leading = separatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = separatorView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = separatorView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = separatorView.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }
}
