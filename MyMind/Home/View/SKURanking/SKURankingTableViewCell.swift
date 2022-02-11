//
//  SKURankingTableViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

enum GradientDirection {
    case topDown, leftRight
}

final class SKURankingTableViewCell: UITableViewCell {
    
    private var cellType = SKURankingReportList.sevenDaysType.commodity
    private let gradientLayer = CAGradientLayer()
    private var progressWidthConstraint = NSLayoutConstraint()

    private let skuRankingImage: UIImage? = {
       return UIImage(named: "sku_ranking")
    }()
    
    private let skuSetRankingImage: UIImage? = {
       return UIImage(named: "sku_set_ranking")
    }()
    
    private let skuRankingProgressColor: [UIColor] = [
        UIColor(hex: "50d6ff"),
        UIColor(hex: "3b4bea"),
        UIColor(hex: "9827d5")
    ]
    
    private let skuSetRankingProgressColor: [UIColor] = [
        UIColor(hex: "ffd67d"),
        UIColor(hex: "f94f27"),
        UIColor(hex: "fe2c7d")
    ]

    private let rankingLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = .white
    }
    
    private let rankingImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "sku_ranking")
        $0.layer.masksToBounds = false
    }
    
    private let titleLabel: UILabel = UILabel {
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
        $0.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = progressView.bounds
    }
    
    func config(type: SKURankingReportList.sevenDaysType, sortOrder: SKURankingReport.SKURankingReportSortOrder, index: Int, progress: Float, item: SKURankingReport?) {
        cellType = type
        titleLabel.text = item?.name ?? ""
        rankingLabel.text = "\(index + 1)"
        
        // 設定總額或數量
        var progressValue: Float = 0
        switch sortOrder {
        case .TOTAL_SALE_QUANTITY:
            progressValue = Float(item?.saleQuantity ?? 0)
        case .TOTAL_SALE_AMOUNT:
            progressValue = item?.saleAmount ?? 0
        }
        progressLabel.text = progressValue.roundToInt()?.toDecimalString() ?? "0"

        // 設定進度條
        progressView.removeGradient()
        switch type {
        case .commodity:
            rankingImageView.image = skuRankingImage
            progressBackgroundView.backgroundColor = UIColor(hex: "f1effd")
            progressView.addGradient(with: gradientLayer, colorSet: skuRankingProgressColor, direction: .leftRight, layerCornerRadius: 11.5)
            progressView.applySketchShadow(
                color: UIColor.init(hex: "#9129d6").withAlphaComponent(0.3),
                alpha: 1,
                x: 0, y: 7,
                blur: 7,
                spread: 0
            )
        case .combined_commodity:
            rankingImageView.image = skuSetRankingImage
            progressBackgroundView.backgroundColor = UIColor(hex: "feede9")
            progressView.addGradient(with: gradientLayer, colorSet: skuSetRankingProgressColor, direction: .leftRight, layerCornerRadius: 11.5)
            progressView.applySketchShadow(
                color: UIColor.init(hex: "#f94f27").withAlphaComponent(0.3),
                alpha: 1,
                x: 0, y: 7,
                blur: 7,
                spread: 0
            )
        }
        
        // 設定進度條寛度
        let progressLabelWidth = CGFloat(20) + CGFloat(progressLabel.getFontSize(.pingFangTCRegular(ofSize: 12))?.width ?? 0)
        let progressBarWidth = CGFloat(progress * 120)
        progressWidthConstraint.constant = progressBarWidth > progressLabelWidth ? progressBarWidth : progressLabelWidth
    }
        
    private func constructViewHierarchy() {
        contentView.addSubview(rankingImageView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressBackgroundView)
        contentView.addSubview(progressView)
        progressView.addSubview(progressLabel)
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
        let centerY = progressView.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let trail = progressView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -16)
        progressWidthConstraint = progressView.widthAnchor
            .constraint(equalToConstant: 120)
        let height = progressView.heightAnchor
            .constraint(equalTo: progressBackgroundView.heightAnchor)
        NSLayoutConstraint.activate([
            centerY, trail, height, progressWidthConstraint
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
