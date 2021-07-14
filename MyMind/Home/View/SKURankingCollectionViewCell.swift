//
//  SKURankingCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SKURankingCollectionViewCell: UICollectionViewCell {
    var infoView: SKURankingInfoView!
    func config(with rankingList: SKURankingReportList?, order: SKURankingReportSortOrder) {
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        infoView = SKURankingInfoView(frame: bounds, rankingList: rankingList, order: order)
        contentView.addSubview(infoView)
    }
}
