//
//  TodaySaleReportCollectionViewswift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class TodaySaleReportCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var todaySaleReportCollectionView: UICollectionView!
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView(
            frame: CGRect(origin: .zero, size: .init(width: contentView.frame.width, height: 56)),
            title: "今日數據"
        )
        view.backgroundColor = .prussianBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewPager: ViewPager = {
        let viewPager = ViewPager(tabSizeConfiguration: .fillEqually(height: 50, spacing: 0))
        viewPager.tabbedView.tabs = [
            TodayTabItemView(title: "銷售數據"),
            TodayTabItemView(title: "取消數據"),
            TodayTabItemView(title: "退貨數據")
        ]
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        return viewPager
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = .white
        constructViewHierarchy()
        activateConstratins()
    }
    
    func config(with saleReports: SaleReports?) {
        headerView.alternativeInfo = saleReports?.dateString ?? Date().shortDateString
        constructViewHierarchy()
        activateConstratins()
        
        viewPager.pagedView.pages = [
            SaleReportInfoView(frame: bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)), saleReports: saleReports, type: .sale),
            SaleReportInfoView(frame: bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)), saleReports: saleReports, type: .canceled),
            SaleReportInfoView(frame: bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)), saleReports: saleReports, type: .sale_return)
        ]
    }
}

// MARK: - UI Setup

extension TodaySaleReportCollectionViewCell {
    
    func constructViewHierarchy() {
        contentView.addSubview(headerView)
        contentView.addSubview(viewPager)
    }

    func activateConstratins() {
        activateConstraintsHeaderView()
        activateConstraintsViewPager()
    }
    
    func activateConstraintsHeaderView() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    func activateConstraintsViewPager() {
        NSLayoutConstraint.activate([
            viewPager.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            viewPager.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            viewPager.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            viewPager.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

