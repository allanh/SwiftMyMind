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

        let view1 = UIView()
        view1.backgroundColor = .red

        let view2 = UIView()
        view2.backgroundColor = .blue

        let view3 = UIView()
        view3.backgroundColor = .orange

        viewPager.tabbedView.tabs = [
            TodayTabItemView(title: "銷售數據"),
            TodayTabItemView(title: "取消數據"),
            TodayTabItemView(title: "退貨數據")
        ]
        viewPager.pagedView.pages = [
            view1,
            view2,
            view3
        ]
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        return viewPager
    }()
    
    private var saleReports: SaleReports? {
        didSet {
//            todaySaleReportCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = .white
        constructViewHierarchy()
        activateConstratins()
//        todaySaleReportCollectionView.dataSource = self
//        todaySaleReportCollectionView.delegate = self
//        todaySaleReportCollectionView.clipsToBounds = true
//        todaySaleReportCollectionView.layer.cornerRadius = 16
//        todaySaleReportCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func config(with saleReports: SaleReports?) {
        self.saleReports = saleReports
        headerView.alternativeInfo = saleReports?.date ?? ""
        constructViewHierarchy()
        activateConstratins()
//        clipsToBounds = true
//        layer.cornerRadius = 16
//        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    func activateConstraintsViewPager() {
        NSLayoutConstraint.activate([
            viewPager.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewPager.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewPager.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            viewPager.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

//extension TodaySaleReportCollectionViewCell: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodaySaleInfoCollectionViewCell", for: indexPath) as? TodaySaleInfoCollectionViewCell {
//            config(with: saleReports, at: indexPath.item)
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//}
//extension TodaySaleReportCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return  CGSize(width: todaySaleReportCollectionView.bounds.size.width-20, height: todaySaleReportCollectionView.bounds.size.height-16)
//    }
//}

