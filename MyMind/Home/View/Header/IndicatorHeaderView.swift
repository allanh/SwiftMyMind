//
//  IndicatorHeaderView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class IndicatorHeaderView: NiblessView {
    var hierarchyNotReady: Bool = true
    let indicatorWidth: CGFloat
    let title: String
    let alternativeInfo: String?
    init(frame: CGRect, indicatorWidth: CGFloat, title: String, alternativeInfo: String? = nil) {
        self.indicatorWidth = indicatorWidth
        self.title = title
        self.alternativeInfo = alternativeInfo
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        backgroundColor = .systemBackground
        titleLabel.text = title
        if let alternativeInfo = alternativeInfo {
            alternativeLabel.text = alternativeInfo
        }
        hierarchyNotReady = false
    }
    private let indicatorView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "1c4373")
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 16)
        $0.textColor = .secondaryLabel
    }
    private let alternativeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 12)
        $0.textColor = .tertiaryLabel
        $0.textAlignment = .right

    }
//    private let seperatorView: UIView = UIView {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.backgroundColor = .secondarySystemBackground
//    }
}
extension IndicatorHeaderView {
    private func arrangeView() {
        
        addSubview(indicatorView)
        addSubview(titleLabel)
        if alternativeInfo != nil {
            addSubview(alternativeLabel)
        }
//        addSubview(seperatorView)
    }
    private func activateConstraints() {
        activateConstraintsIndicatorView()
        activateConstraintsTitleLabel()
        if alternativeInfo != nil {
            activateConstraintsAlternativeLabel()
        }
//        activateConstraintsSeperatorView()
    }
}
extension IndicatorHeaderView {
    private func activateConstraintsIndicatorView() {
        let top = indicatorView.topAnchor
            .constraint(equalTo: topAnchor, constant: 8)
        let bottom = indicatorView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -8)
        let width = indicatorView.widthAnchor
            .constraint(equalToConstant: indicatorWidth)
        let leading = indicatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)

        NSLayoutConstraint.activate([
            top, bottom, leading, width
        ])
    }
    private func activateConstraintsTitleLabel() {
        let top = titleLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: 8)
        let bottom = titleLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -8)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: indicatorView.trailingAnchor, constant: 8)
//        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            top, bottom, leading//, trailing
        ])
    }
    private func activateConstraintsAlternativeLabel() {
        let centerY = alternativeLabel.centerYAnchor
            .constraint(equalTo: titleLabel.centerYAnchor)
        let leading = alternativeLabel.leadingAnchor
            .constraint(equalTo: titleLabel.trailingAnchor, constant: 8)
        let trailing = alternativeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
//    private func activateConstraintsSeperatorView() {
//        let trailing = seperatorView.trailingAnchor
//            .constraint(equalTo: trailingAnchor, constant: 0)
//        let leading = seperatorView.leadingAnchor
//            .constraint(equalTo: leadingAnchor, constant: 0)
//        let height = seperatorView.heightAnchor
//            .constraint(equalToConstant: 1)
//
//        let bottom = seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
//        NSLayoutConstraint.activate([
//            leading, trailing, height, bottom
//        ])
//    }
}
protocol IndicatorSwitchContentHeaderViewDelegate: AnyObject {
    func contentNeedSwitch(to index: Int, for section: Section)
}
