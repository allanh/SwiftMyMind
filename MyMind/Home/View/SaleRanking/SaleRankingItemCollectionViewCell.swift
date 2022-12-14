//
//  SaleRankingCollectionViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2022/1/11.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

class SaleRankingItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    
    var raningView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 2
    }
    
    private let contentLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.lineBreakMode = NSLineBreakMode.byWordWrapping
        $0.textColor = .white
    }

    private let valueLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
    }

    func config(type: SaleRankingReportList.RankingType, devider: SaleRankingReport.SaleRankingReportDevider, report: SaleRankingReport?, value: Float) {
        switch devider {
        case .store:
            contentLabel.text = report?.name
        case .vendor:
            if let name = report?.name, !name.isEmpty {
                contentLabel.text = name
            } else {
                contentLabel.text = "未設定供應商"
            }
        }
        valueLabel.text = "\(String(format:"%.2f", value * 100))%"
    }

    private func constructViewHierarchy() {
        contentView.addSubview(raningView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(valueLabel)
    }

    private func activateConstraints() {
        activateConstraintsRaningView()
        activateConstraintsContentLabel()
        activateConstraintsValueLabel()
    }

    func config(with content: String) {
        contentLabel.text = content
    }
}

// MARK: - Layouts
extension SaleRankingItemCollectionViewCell {
    private func activateConstraintsRaningView() {
        let leading = raningView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let top = raningView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let width = raningView.widthAnchor
            .constraint(equalToConstant: 4)
        let height = raningView.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            leading, top, width, height
        ])
    }
    
    private func activateConstraintsContentLabel() {
        let leading = contentLabel.leadingAnchor
            .constraint(equalTo: raningView.trailingAnchor, constant: 8)
        let trailing = contentLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = contentLabel.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let bottom = valueLabel.bottomAnchor
            .constraint(equalTo: valueLabel.topAnchor)
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }

    private func activateConstraintsValueLabel() {
        let leading = valueLabel.leadingAnchor
            .constraint(equalTo: contentLabel.leadingAnchor)
        let trailing = valueLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = valueLabel.topAnchor
            .constraint(equalTo: contentLabel.bottomAnchor, constant: 5)
        let bottom = valueLabel.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
        let height = valueLabel.heightAnchor
            .constraint(equalToConstant: 17)
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom, height
        ])
    }
}
