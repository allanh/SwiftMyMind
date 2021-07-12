//
//  TodaySaleInfoCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class TodaySaleInfoCollectionViewCell: UICollectionViewCell {
    var infoView: SaleReportInfoView!
    func config(with today: SaleReport?, yesterday: SaleReport?, transformed: SaleReport?, shipped: SaleReport?, at index: Int) {
        infoView = SaleReportInfoView(frame: bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)), today: today, yesterday: yesterday, transformed: transformed, shipped: shipped, index: index)
        contentView.addSubview(infoView)
    }
}
