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
    private var saleReports: SaleReports? {
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
    func config(with saleReports: SaleReports?) {
        self.saleReports = saleReports
    }
}
extension TodaySaleReportCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodaySaleInfoCollectionViewCell", for: indexPath) as? TodaySaleInfoCollectionViewCell {
            cell.config(with: saleReports, at: indexPath.item)
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

