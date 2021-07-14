//
//  SKURankingInfoItemView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class SKURankingInfoItemView: NiblessView {
    var hierarchyNotReady: Bool = true
    let ranking: Int
    let report: SKURankingReport?
    let order: SKURankingReportSortOrder
    init(frame: CGRect, ranking: Int, report: SKURankingReport?, order: SKURankingReportSortOrder) {
        self.ranking = ranking
        self.report = report
        self.order = order
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        if let report = report {
            rankingLabel.text = "\(ranking)"
            titleLabel.text = report.name
            countLabel.text = (order == .TOTAL_SALE_AMOUNT) ? "\(report.saleAmount)" : "\(report.saleQuantity)"
            if let urlString = report.image,
               let url = URL(string: urlString) {
                imageView.kf.setImage(with: url)
            } else {
                imageView.image = nil
            }
        }
        hierarchyNotReady = false
    }
    private let rankingLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .label
        $0.font = .pingFangTCRegular(ofSize: 14)
    }
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBlue
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 2
        $0.font = .pingFangTCRegular(ofSize: 16)
    }
    private let countLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.font = .pingFangTCRegular(ofSize: 16)
        $0.textAlignment = .right
    }
}
/// helper
extension SKURankingInfoItemView {
    private func arrangeView() {
        addSubview(rankingLabel)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(countLabel)
    }
    private func activateConstraints() {
        activateConstraintsRankingLabel()
        activateConstraintsImageView()
        activateConstraintsTitleLabel()
        activateConstraintsCountLabel()
    }
}
/// constraints
extension SKURankingInfoItemView {
    private func activateConstraintsRankingLabel() {
        let centerY = rankingLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let leading = rankingLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let width = rankingLabel.widthAnchor.constraint(equalToConstant: 16)

        NSLayoutConstraint.activate([
            leading, centerY, width
        ])
    }
    private func activateConstraintsImageView() {
        let leading = imageView.leadingAnchor
            .constraint(equalTo: rankingLabel.trailingAnchor, constant: 8)
        let top = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        let bottom = imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        #if false
        let width = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        #else
        let width = imageView.widthAnchor.constraint(equalToConstant: 0)
        #endif
        
        NSLayoutConstraint.activate([
            leading, top, bottom, width
        ])
    }
    private func activateConstraintsTitleLabel() {
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: imageView.trailingAnchor, constant: 8)
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let width = titleLabel.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            leading, centerY, width
        ])
    }
    private func activateConstraintsCountLabel() {
        let leading = countLabel.leadingAnchor
            .constraint(equalTo: titleLabel.trailingAnchor, constant: 8)
        let centerY = countLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let trailing = countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            leading, centerY, trailing
        ])
    }
}
