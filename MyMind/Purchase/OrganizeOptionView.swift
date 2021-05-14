//
//  OrganizeOptionView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class OrganizeOptionView: NiblessView {
    let topSeparatorView: UIView = UIView{
        $0.backgroundColor = .init(hex: "e5e5e5")
    }

    let stackView: UIStackView = UIStackView {
        $0.alignment = .center
    }

    let sortButton: UIButton = UIButton {
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.init(hex: "4c4c4c"), for: .normal)
        $0.setImage(UIImage(named: "sort"), for: .normal)
        $0.setTitle("採購單編號", for: .normal)
    }

    let filterButton: UIButton = UIButton {
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.init(hex: "4c4c4c"), for: .normal)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.setTitle("篩選條件", for: .normal)
    }

    let layoutButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "list"), for: .normal)
    }

    let firstSeparatorView: UIView = UIView {
        $0.backgroundColor = .init(hex: "e5e5e5")
    }

    let secondSeparatorView: UIView = UIView {
        $0.backgroundColor = .init(hex: "e5e5e5")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        constructViewHierarchy()
        activateConstraints()
    }

    func constructViewHierarchy() {
        addSubview(topSeparatorView)
        stackView.addArrangedSubview(sortButton)
        stackView.addArrangedSubview(firstSeparatorView)
        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(secondSeparatorView)
        stackView.addArrangedSubview(layoutButton)
        addSubview(stackView)
    }

    func activateConstraints() {
        activateConstraintsTopSeparatorView()
        activateConstraintsStackView()
        activateConstraintsSortButton()
        activateConstraintsSeparatorViews()
        activateConstraintsLayoutButton()
    }
}
extension OrganizeOptionView {
    func activateConstraintsTopSeparatorView() {
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        let top = topSeparatorView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = topSeparatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = topSeparatorView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = topSeparatorView.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = stackView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = stackView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = stackView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    func activateConstraintsSortButton() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.widthAnchor
            .constraint(equalTo: filterButton.widthAnchor).isActive = true
    }

    func activateConstraintsSeparatorViews() {
        firstSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        secondSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        let firstWidth = firstSeparatorView.widthAnchor
            .constraint(equalToConstant: 2)
        let firstHeight = firstSeparatorView.heightAnchor
            .constraint(equalToConstant: 20)
        let secondWidth = secondSeparatorView.widthAnchor
            .constraint(equalToConstant: 2)
        let secondHeight = secondSeparatorView.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            firstWidth, firstHeight, secondWidth, secondHeight
        ])
    }

    func activateConstraintsLayoutButton() {
        layoutButton.translatesAutoresizingMaskIntoConstraints = false
        let width = layoutButton.widthAnchor
            .constraint(equalToConstant: 40)
        let height = layoutButton.heightAnchor
            .constraint(equalTo: layoutButton.widthAnchor)

        NSLayoutConstraint.activate([
            width, height
        ])
    }
}
