//
//  SKURankingInfoView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class SKURankingInfoView: NiblessView {
    var hierarchyNotReady: Bool = true
    let noDataView: NoDataView
    let rankingList: SKURankingReportList?
    let order: SKURankingReport.SKURankingReportSortOrder
    init(frame: CGRect, rankingList: SKURankingReportList?, order: SKURankingReport.SKURankingReportSortOrder) {
        self.rankingList = rankingList
        self.order = order
        self.noDataView = NoDataView()
        super.init(frame: frame)
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        constructViews()
        arrangeView()
        activateConstraints()
        backgroundColor = .systemBackground
        hierarchyNotReady = false
    }
    var itemViews: [SKURankingInfoItemView] = []
}
/// helper
extension SKURankingInfoView {
    private func constructViews() {
        if let rankingList = rankingList {
            for index in 0..<rankingList.reports.count {
                itemViews.append(SKURankingInfoItemView(frame: .zero, ranking: index+1, report: rankingList.reports[index], order: order))
            }
            for index in rankingList.reports.count..<5 {
                itemViews.append(SKURankingInfoItemView(frame: .zero, ranking: index+1, report: nil, order: order))
            }
        } else {
            for index in 0..<5 {
                itemViews.append(SKURankingInfoItemView(frame: .zero, ranking: index+1, report: nil, order: order))
            }
        }
    }
    private func arrangeView() {
        if itemViews.count > 0 {
            for index in 0..<itemViews.count {
                addSubview(itemViews[index])
            }
        } else {
            addSubview(noDataView)
        }
    }
}
/// constraints
extension SKURankingInfoView {
    private func activateConstraints() {
        if itemViews.count > 0 {
            var offsetY: CGFloat = 0
            for index in 0..<itemViews.count {
                let leading = itemViews[index].leadingAnchor
                    .constraint(equalTo: leadingAnchor, constant: 8)
                let trailing = itemViews[index].trailingAnchor
                    .constraint(equalTo: trailingAnchor, constant: -8)
                let top = itemViews[index].topAnchor
                    .constraint(equalTo: topAnchor, constant: 8+offsetY)
                let height = itemViews[index].heightAnchor
                    .constraint(equalToConstant: 44)
                NSLayoutConstraint.activate([
                    leading, trailing, top, height
                ])
                offsetY += 44
            }
        } else {
            let leading = noDataView.leadingAnchor.constraint(equalTo: leadingAnchor)
            let trailing = noDataView.trailingAnchor.constraint(equalTo: trailingAnchor)
            let top = noDataView.topAnchor.constraint(equalTo: topAnchor)
            let bottom = noDataView.bottomAnchor.constraint(equalTo: bottomAnchor)
            NSLayoutConstraint.activate([
                leading, trailing, top, bottom
            ])
        }
    }
}
