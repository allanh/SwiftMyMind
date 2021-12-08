//
//  HomeCollectionViewHeaderView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class HomeCollectionViewHeaderView: UICollectionReusableView {
    func config(with width: CGFloat, title: String) {
        let contentView = IndicatorHeaderView(frame: bounds, indicatorWidth: width, title: title)
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
class HomeCollectionViewSwitchContentHeaderView: UICollectionReusableView {
    func config(with width: CGFloat, title: String, switcher: SwitcherInfo, delegate: IndicatorSwitchContentHeaderViewDelegate?) {
        let contentView = IndicatorSwitchContentHeaderView(frame: bounds, indicatorWidth: width, title: title, switcher: switcher, delegate: delegate)
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
