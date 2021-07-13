//
//  TodaySaleReportCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class TodaySaleReportCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var todaySaleReportCollectionView: UICollectionView!
    private var reportOfToday: SaleReport?  {
        didSet {
            todaySaleReportCollectionView.reloadData()
        }
    }
    private var reportOfYesterday: SaleReport?  {
        didSet {
            todaySaleReportCollectionView.reloadData()
        }
    }
    private var transformed: SaleReport?  {
        didSet {
            todaySaleReportCollectionView.reloadData()
        }
    }
    private var shipped: SaleReport?  {
        didSet {
            todaySaleReportCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        todaySaleReportCollectionView.dataSource = self
        todaySaleReportCollectionView.delegate = self
        todaySaleReportCollectionView.clipsToBounds = true
        todaySaleReportCollectionView.layer.cornerRadius = 16
        todaySaleReportCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    func config(with today: SaleReport?, yesterday: SaleReport?, transformed: SaleReport?, shipped: SaleReport?) {
        self.reportOfToday = today
        self.reportOfYesterday = yesterday
        self.transformed = transformed
        self.shipped = shipped
    }

}
extension TodaySaleReportCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodaySaleInfoCollectionViewCell", for: indexPath) as? TodaySaleInfoCollectionViewCell {
            cell.config(with: reportOfToday, yesterday: reportOfYesterday, transformed: transformed, shipped: shipped, at: indexPath.item)
            return cell
        }
        return UICollectionViewCell()
    }
}
extension TodaySaleReportCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: todaySaleReportCollectionView.bounds.size.width-20, height: todaySaleReportCollectionView.bounds.size.height-16)
    }
}

