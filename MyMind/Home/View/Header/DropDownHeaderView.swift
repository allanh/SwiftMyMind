//
//  DropDownHeaderView.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/16.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class DropDownHeaderView : NiblessView {
    var hierarchyNotReady: Bool = true
    let title: String
    var date: String? {
        didSet {
            dateLabel.text = date ?? ""
        }
    }
    var alternativeInfo: String? {
        didSet {
            alternativeLabel.text = alternativeInfo ?? ""
        }
    }
    
    init(frame: CGRect, title: String, alternativeInfo: String? = nil, date: String? = nil) {
        self.title = title
        self.date = date
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
        backgroundColor = .clear
        titleLabel.text = title
        if let alternativeInfo = alternativeInfo {
            alternativeLabel.text = alternativeInfo
        }
        if let date = date {
            dateLabel.text = date
        }
        hierarchyNotReady = false
    }

    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = .white
    }
    
    private let dateLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 12)
        $0.textColor = .white
    }

    // Drop down view
    let alternativeInfoView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .monthlyReportDropDownBg
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    private let alternativeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = .white
    }
    
    private let arrowDownImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "arrow_down")
        $0.contentMode = .scaleAspectFit
    }
}

extension DropDownHeaderView {
    private func arrangeView() {
        addSubview(titleLabel)
        if date != nil {
            addSubview(dateLabel)
        }
        alternativeInfoView.addSubview(alternativeLabel)
        alternativeInfoView.addSubview(arrowDownImageView)
        addSubview(alternativeInfoView)
    }
    
    private func activateConstraints() {
        activateConstraintsTitleLabel()
        if date != nil {
            activateConstraintsdateLabel()
        }
        activateConstraintsAlternativeInfoView()
        activateConstraintsAlternativeLabel()
        activateConstraintsArrowDownImageView()
    }
}

extension DropDownHeaderView {
    private func activateConstraintsTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    private func activateConstraintsdateLabel() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 17),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    private func activateConstraintsAlternativeInfoView() {
        NSLayoutConstraint.activate([
            alternativeInfoView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            alternativeInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            alternativeInfoView.widthAnchor.constraint(equalToConstant: 100),
            alternativeInfoView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func activateConstraintsAlternativeLabel() {
        NSLayoutConstraint.activate([
            alternativeLabel.centerYAnchor.constraint(equalTo: alternativeInfoView.centerYAnchor),
            alternativeLabel.leadingAnchor.constraint(equalTo: alternativeInfoView.leadingAnchor, constant: 16),
            alternativeLabel.trailingAnchor.constraint(equalTo: arrowDownImageView.leadingAnchor, constant: -4),
            alternativeLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func activateConstraintsArrowDownImageView() {
        NSLayoutConstraint.activate([
            arrowDownImageView.centerYAnchor.constraint(equalTo: alternativeInfoView.centerYAnchor),
            arrowDownImageView.leadingAnchor.constraint(equalTo: alternativeLabel.trailingAnchor, constant: 4),
            arrowDownImageView.trailingAnchor.constraint(equalTo: alternativeInfoView.trailingAnchor, constant: -8),
            arrowDownImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowDownImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
