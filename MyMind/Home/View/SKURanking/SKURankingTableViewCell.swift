//
//  SKURankingTableViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class SKURankingTableViewCell: UITableViewCell {
    
    var cellType = SKURankingReportList.sevenDaysType.commodity
    
    let skuRankingImage: UIImage? = {
       return UIImage(named: "sku_ranking")
    }()
    
    let skuSetRankingImage: UIImage? = {
       return UIImage(named: "sku_set_ranking")
    }()
    
    let skuRankingProgressColor: [CGColor] = [
        UIColor(hex: "50d6ff").cgColor,
        UIColor(hex: "3b4bea").cgColor,
        UIColor(hex: "9827d5").cgColor
    ]
    
    let skuSetRankingProgressColor: [CGColor] = [
        UIColor(hex: "ffd67d").cgColor,
        UIColor(hex: "f94f27").cgColor,
        UIColor(hex: "fe2c7d").cgColor
    ]

    let rankingLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = .white
    }
    
    let rankingImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "sku_ranking")
        $0.layer.masksToBounds = false
    }
    
    let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .emperor
        $0.numberOfLines = 2
    }
    
    private let progressBackgroundView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 11.5
    }

    private let progressView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 11.5
    }
    
    private let progressLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch cellType {
        case .commodity:
            progressView.addGradient(skuRankingProgressColor, direction: .leftRight, layerCornerRadius: 11.5)
        case .combined_commodity:
            progressView.addGradient(skuSetRankingProgressColor, direction: .leftRight, layerCornerRadius: 11.5)
        }
    }
    
    func config(type: SKURankingReportList.sevenDaysType, index: Int, item: SKURankingReport?) {
        cellType = type
        titleLabel.text = item?.name ?? ""
        rankingLabel.text = "\(index + 1)"
        switch type {
        case .commodity:
            rankingImageView.image = skuRankingImage
            progressBackgroundView.backgroundColor = UIColor(hex: "f1effd")
        case .combined_commodity:
            rankingImageView.image = skuSetRankingImage
            progressBackgroundView.backgroundColor = UIColor(hex: "feede9")
        }
    }

    private func constructViewHierarchy() {
        contentView.addSubview(rankingImageView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressBackgroundView)
        contentView.addSubview(progressView)
        contentView.addSubview(progressLabel)
    }

    private func activateConstraints() {
        activateConstraintsRankingImageView()
        activateConstraintsRankingLabel()
        activateConstraintsTitleLabel()
        activateConstraintsProgressBackgroundView()
        activateConstraintsProgressView()
        activateConstraintsProgressLabel()
    }

    private func activateConstraintsRankingImageView() {
        let top = rankingImageView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 4)
        let leading = rankingImageView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let width = rankingImageView.widthAnchor
            .constraint(equalToConstant: 24)
        let height = rankingImageView.heightAnchor
            .constraint(equalTo: rankingImageView.widthAnchor)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    
    private func activateConstraintsRankingLabel() {
        let centerX = rankingLabel.centerXAnchor
            .constraint(equalTo: rankingImageView.centerXAnchor)
        let centerY = rankingLabel.centerYAnchor
            .constraint(equalTo: rankingImageView.centerYAnchor)
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    
    private func activateConstraintsTitleLabel() {
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: rankingImageView.trailingAnchor, constant: 18)
        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }
    
    private func activateConstraintsProgressBackgroundView() {
        let centerY = progressBackgroundView.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = progressBackgroundView.leadingAnchor
            .constraint(equalTo: titleLabel.trailingAnchor, constant: 2)
        let trail = progressBackgroundView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -16)
        let width = progressBackgroundView.widthAnchor
            .constraint(equalToConstant: 120)
        let height = progressBackgroundView.heightAnchor
            .constraint(equalToConstant: 23)
        NSLayoutConstraint.activate([
            centerY, leading, trail, width, height
        ])
    }
    
    private func activateConstraintsProgressView() {
        let top = progressView.topAnchor
            .constraint(equalTo: progressBackgroundView.topAnchor)
        let bottom = progressView.bottomAnchor
            .constraint(equalTo: progressBackgroundView.bottomAnchor)
        let trail = progressView.trailingAnchor
            .constraint(equalTo: progressBackgroundView.trailingAnchor)
        let width = progressView.widthAnchor
            .constraint(equalToConstant: 60)
        let height = progressView.heightAnchor
            .constraint(equalTo: progressBackgroundView.heightAnchor)
        NSLayoutConstraint.activate([
            top, bottom, trail, width, height
        ])
    }
    
    private func activateConstraintsProgressLabel() {
        let centerY = progressLabel.centerYAnchor
            .constraint(equalTo: progressView.centerYAnchor)
        let trail = progressLabel.trailingAnchor
            .constraint(equalTo: progressView.trailingAnchor, constant: -10)
        let height = progressLabel.heightAnchor
            .constraint(equalToConstant: 17)
        NSLayoutConstraint.activate([
            centerY, trail, height
        ])
    }
}
