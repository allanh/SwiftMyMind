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
        $0.backgroundColor = .mercury
    }

    let stackView: UIStackView = UIStackView {
        $0.alignment = .center
    }

    let sortButton: UIButton = UIButton {
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.veryDarkGray, for: .normal)
        $0.setImage(UIImage(named: "sort"), for: .normal)
    }

    let filterButton: UIButton = UIButton {
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.veryDarkGray, for: .normal)
        $0.setImage(UIImage(named: "filter"), for: .normal)
       // $0.setTitle("篩選條件", for: .normal)
    }

    let layoutButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "list"), for: .normal)
    }

    let firstSeparatorView: UIView = UIView {
        $0.backgroundColor = .mercury
    }

    let secondSeparatorView: UIView = UIView {
        $0.backgroundColor = .mercury
    }
    
    let announcementFilterButton: FilterViewToggleButton = FilterViewToggleButton {
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.veryDarkGray, for: .normal)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.setImage(UIImage(named: "filter_selected"), for: .selected)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .veryLightPink
    }
    
    let announcementSortButton: UIButton = UIButton {
        $0.isSelected = false
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.veryDarkGray, for: .normal)
        $0.setImage(UIImage(named: "announcement_sort"), for: .normal)
        $0.setImage(UIImage(named: "announcement_sort_selected"), for: .selected)
        $0.setTitle("發布時間", for: .normal)
        $0.layer.cornerRadius = 15
        $0.semanticContentAttribute = .forceRightToLeft
        $0.backgroundColor = UIColor(hex: "f1f8fe")
        $0.setTitleColor(.prussianBlue, for: .selected)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.prussianBlue.cgColor
    }
    
    let annoucementIsTopButton: UIButton = UIButton {
        $0.isSelected = false
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.veryDarkGray, for: .normal)
        $0.setTitle("釘選", for: .normal)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .veryLightPink
        $0.setTitleColor(.prussianBlue, for: .selected)
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

    func setupForAnnouncement() {
        constructViewHierarchyForAnnouncement()
        activateConstraintsForAnnouncement()
    }

    func constructViewHierarchyForAnnouncement() {
        stackView.addSubview(announcementFilterButton)
        stackView.addSubview(announcementSortButton)
        addSubview(stackView)
        stackView.addSubview(topSeparatorView)
        stackView.addSubview(annoucementIsTopButton)
    }

    func activateConstraintsForAnnouncement() {
        activateConstraintsStackView()
        activateConstraintsSortButtonForAnnouncement()
        activateConstraintsFilterButtonForAnnouncement()
        activateConstraintsSeparatorView()
        activateConstraintsIsTopButtonForAnnouncement()
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

    private func activatConstaintsFirstSeparatorView() {
        firstSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = firstSeparatorView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        let centerY = firstSeparatorView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        let width = firstSeparatorView.widthAnchor.constraint(equalToConstant: 2)
        let height = firstSeparatorView.heightAnchor.constraint(equalToConstant: 20)
        
        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }

    private func activateConstraintsSortButtonForAnnouncement() {
        announcementSortButton.translatesAutoresizingMaskIntoConstraints = false
        let centerY = announcementSortButton.centerYAnchor
            .constraint(equalTo: stackView.centerYAnchor)
        let leading = announcementSortButton.leadingAnchor
            .constraint(equalTo: stackView.leadingAnchor, constant: 16)
        let width = announcementSortButton.widthAnchor
            .constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            centerY, leading, width
        ])
    }

    private func activateConstraintsFilterButtonForAnnouncement() {
        announcementFilterButton.translatesAutoresizingMaskIntoConstraints = false
        let centerY = announcementFilterButton.centerYAnchor
            .constraint(equalTo: stackView.centerYAnchor)
        let trailing = announcementFilterButton.trailingAnchor
            .constraint(equalTo: stackView.trailingAnchor, constant: -18)
        let height = announcementFilterButton.heightAnchor
            .constraint(equalToConstant: 32)
        let width = announcementFilterButton.widthAnchor
            .constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            centerY, trailing, height, width
        ])
    }

    private func activateConstraintsSeparatorView() {
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        let top = topSeparatorView.topAnchor
            .constraint(equalTo: stackView.bottomAnchor)
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

    private func activateConstraintsIsTopButtonForAnnouncement() {
        annoucementIsTopButton.translatesAutoresizingMaskIntoConstraints = false
        let centerY = annoucementIsTopButton.centerYAnchor
            .constraint(equalTo: stackView.centerYAnchor)
        let leading = annoucementIsTopButton.leadingAnchor
            .constraint(equalTo: announcementSortButton.trailingAnchor, constant: 10)
        let height = annoucementIsTopButton.heightAnchor
            .constraint(equalTo: announcementSortButton.heightAnchor)
        let width = annoucementIsTopButton.widthAnchor
            .constraint(equalToConstant: 56)
        NSLayoutConstraint.activate([
        centerY, leading, height, width
        ])
    }
}
final class ReviewingOrganizeOptionView: NiblessView {
}
