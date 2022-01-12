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

    private let images = ["sale_ranking_1", "sale_ranking_2", "sale_ranking_3", "sale_ranking_4", "sale_ranking_5", "sale_ranking_6"]
    
    private let raningImage: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let contentLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.numberOfLines = 2
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

    func config(type: SaleRankingReportList.RankingType, index: Int, report: SaleRankingReport?) {
//        contentView.layer.cornerRadius = 4
//        contentView.backgroundColor = .lightGray
//        contentView.clipsToBounds = true
        if let image = images.getElement(at: index) {
            raningImage.setBackgroundImage(image)
        }
        contentLabel.text = report?.name
        
        let value = type == .sale ? report?.saleAmount : report?.saleGrossProfit
        valueLabel.text = "\(value ?? 0)%"
    }

    private func constructViewHierarchy() {
        contentView.addSubview(raningImage)
        contentView.addSubview(contentLabel)
        contentView.addSubview(valueLabel)
    }

    private func activateConstraints() {
        activateConstraintsRaningImage()
        activateConstraintsContentLabel()
        activateConstraintsValueLabel()
    }

    func config(with content: String) {
        contentLabel.text = content
    }
}
// MARK: - Layouts
extension SaleRankingItemCollectionViewCell {
    private func activateConstraintsRaningImage() {
        let leading = raningImage.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let top = raningImage.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let width = raningImage.widthAnchor
            .constraint(equalToConstant: 4)
        let height = raningImage.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            leading, top, width, height
        ])
    }
    
    private func activateConstraintsContentLabel() {
        let leading = contentLabel.leadingAnchor
            .constraint(equalTo: raningImage.trailingAnchor, constant: 8)
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
