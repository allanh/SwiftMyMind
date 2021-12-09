//
//  HeaderView.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class HeaderView: NiblessView {
    var hierarchyNotReady: Bool = true
    let title: String
    var alternativeInfo: String? {
        didSet {
            alternativeLabel.text = alternativeInfo ?? ""
        }
    }
    
    init(frame: CGRect, title: String, alternativeInfo: String? = nil) {
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

    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = .prussianBlue
    }
    private let alternativeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 12)
        $0.textColor = .brownGrey2
        $0.textAlignment = .right

    }
//    private let seperatorView: UIView = UIView {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.backgroundColor = .secondarySystemBackground
//    }
}
extension HeaderView {
    private func arrangeView() {
        
//        addSubview(indicatorView)
        addSubview(titleLabel)
        if alternativeInfo != nil {
            addSubview(alternativeLabel)
        }
//        addSubview(seperatorView)
    }
    private func activateConstraints() {
//        activateConstraintsIndicatorView()
        activateConstraintsTitleLabel()
        if alternativeInfo != nil {
            activateConstraintsAlternativeLabel()
        }
//        activateConstraintsSeperatorView()
    }
}
extension HeaderView {
//    private func activateConstraintsIndicatorView() {
//        let top = indicatorView.topAnchor
//            .constraint(equalTo: topAnchor, constant: 8)
//        let bottom = indicatorView.bottomAnchor
//            .constraint(equalTo: bottomAnchor, constant: -8)
//        let width = indicatorView.widthAnchor
//            .constraint(equalToConstant: indicatorWidth)
//        let leading = indicatorView.leadingAnchor
//            .constraint(equalTo: leadingAnchor, constant: 8)
//
//        NSLayoutConstraint.activate([
//            top, bottom, leading, width
//        ])
//    }
    private func activateConstraintsTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    private func activateConstraintsAlternativeLabel() {
        NSLayoutConstraint.activate([
            alternativeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            alternativeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            alternativeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
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
