//
//  FilterSideMenuBottomView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class FilterSideMenuBottomView: NiblessView {
    private let stackView: UIStackView = UIStackView {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    let confirmButton: UIButton = UIButton {
        $0.setTitle("搜尋", for: .normal)
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.backgroundColor = UIColor(hex: "004477")
        $0.tintColor = .white
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }

    let cancelButton: UIButton = UIButton {
        $0.setTitle("清除", for: .normal)
        $0.setTitleColor(UIColor(hex: "004477"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
    }

    private let separatorView: UIView = UIView {
        $0.backgroundColor = .separator
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        addSubview(separatorView)
    }

    private func activateConstraints() {
        activateConstraintsStackView()
        activateConstraintsSeparatorView()
    }
}
// MARK: - Layouts
extension FilterSideMenuBottomView {
    private func activateConstraintsStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = stackView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let leading = stackView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 20)
        let trailing = stackView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -20)
        let height = stackView.heightAnchor
            .constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([
            centerY, leading, trailing, height
        ])
    }

    private func activateConstraintsSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        let top = separatorView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = separatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = separatorView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = separatorView.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
}
