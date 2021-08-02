//
//  OrganizeOptionView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class OrganizeOptionView: NiblessView {
    struct DisplayType: OptionSet {
        let rawValue: Int
        static let sort = DisplayType(rawValue: 1 << 0)
        static let filter = DisplayType(rawValue: 1 << 1)
        static let layout = DisplayType(rawValue: 1 << 2)
        static let all: Self = [.sort, .filter, .layout]
    }
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
    var displayType: DisplayType = .all
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    func setup() {
        constructViewHierarchy()
        activateConstraints()
    }
    func constructViewHierarchy() {
        addSubview(topSeparatorView)
        if displayType.contains(.sort) {
            stackView.addArrangedSubview(sortButton)
            sortButton.setTitle("填單日期", for: .normal)
        }
        if displayType.contains(.filter) {
            stackView.addArrangedSubview(firstSeparatorView)
            stackView.addArrangedSubview(filterButton)
        } else {
            sortButton.contentHorizontalAlignment = .left
            sortButton.contentEdgeInsets.left = 10
        }
        if displayType.contains(.layout) {
            stackView.addArrangedSubview(secondSeparatorView)
            stackView.addArrangedSubview(layoutButton)
        }
        addSubview(stackView)
    }

    func activateConstraints() {
        activateConstraintsTopSeparatorView()
        activateConstraintsStackView()
        if displayType.contains(.sort) { activateConstraintsSortButton() }
        if displayType.contains(.filter) { activateConstraintsFilterButton() }
        activateConstraintsSeparatorViews()
        if displayType.contains(.layout) { activateConstraintsLayoutButton() }
    }
}
extension OrganizeOptionView {
    private func activateConstraintsTopSeparatorView() {
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

    private func activateConstraintsStackView() {
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

    private func activateConstraintsSortButton() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        if displayType.contains(.filter) {
            sortButton.widthAnchor
                .constraint(equalTo: filterButton.widthAnchor).isActive = true
        }
        sortButton.heightAnchor
            .constraint(equalTo: stackView.heightAnchor).isActive = true
    }

    private func activateConstraintsFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.heightAnchor
            .constraint(equalTo: stackView.heightAnchor).isActive = true
    }

    private func activateConstraintsSeparatorViews() {
        firstSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        secondSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        if displayType.contains(.filter) {
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
        } else {
            let secondWidth = secondSeparatorView.widthAnchor
                .constraint(equalToConstant: 2)
            let secondHeight = secondSeparatorView.heightAnchor
                .constraint(equalToConstant: 20)

            NSLayoutConstraint.activate([
                secondWidth, secondHeight
            ])
        }
    }

    private func activateConstraintsLayoutButton() {
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
final class ReviewingOrganizeOptionView: NiblessView {
}
