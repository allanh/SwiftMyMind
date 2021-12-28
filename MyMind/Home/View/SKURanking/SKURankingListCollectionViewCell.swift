//
//  SKURankingListCollectionViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/21.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

protocol SKURankingListCollectionViewCellDelegate: AnyObject {
    func showLoading(_ isNetworkProcessing: Bool)
    func handlerCellError(_ error: Error)
}

class SKURankingListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var skuRankingListCollectionView: UICollectionView!
    private weak var delegate: SKURankingListCollectionViewCellDelegate?
    
    private var skuRankingSortOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            loadSkuRankingReportList()
        }
    }
    private var skuSetRankingSortOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            loadSkuSetRankingReportList()
        }
    }
    private var skuRankingReportList: SKURankingReportList? {
        didSet {
            skuRankingListCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
//            scrollThenReset(Section.sevenDaysSKU.rawValue)
        }
    }
    private var skuSetRankingReportList: SKURankingReportList? {
        didSet {
            skuRankingListCollectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
//            scrollThenReset(Section.sevenDaysSKU.rawValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        skuRankingListCollectionView.dataSource = self
        skuRankingListCollectionView.delegate = self
        contentView.backgroundColor = .clear
        if let layout = skuRankingListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
//            layout.minimumLineSpacing = 15
//            layout.minimumInteritemSpacing = 0
            skuRankingListCollectionView.collectionViewLayout = layout
        }
    }
    
    func config(delegate: SKURankingListCollectionViewCellDelegate? = nil) {
        self.delegate = delegate
        loadSkuRankingReportList()
        loadSkuSetRankingReportList()
    }
    
    private func loadSkuRankingReportList() {
        self.delegate?.showLoading(true)
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.skuRankingReport(start: end.sevenDaysBefore, end: end.yesterday, isSet: false, order: skuRankingSortOrder.rawValue, count: 5)
            .done { rankingReportList in
                self.skuRankingReportList = rankingReportList
            }
            .ensure {
                self.delegate?.showLoading(false)
            }
            .catch { error in
                self.skuRankingReportList = nil
                self.delegate?.handlerCellError(error)
            }
    }
    
    private func loadSkuSetRankingReportList() {
        self.delegate?.showLoading(true)
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.skuRankingReport(start: end.sevenDaysBefore, end: end.yesterday, isSet: true, order: skuSetRankingSortOrder.rawValue, count: 5)
            .done { setRankingReportList in
                self.skuSetRankingReportList = setRankingReportList
            }
            .ensure {
                self.delegate?.showLoading(false)
            }
            .catch { error in
                self.skuSetRankingReportList = nil
                self.delegate?.handlerCellError(error)
            }
    }
}
extension SKURankingListCollectionViewCell: UICollectionViewDataSource {    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
            cell.backgroundColor = .clear
            if indexPath.row == 0 {
                cell.config(type: .commodity, currentOrder: skuRankingSortOrder, rankingList: skuRankingReportList, delegate: self)
            } else {
                cell.config(type: .combined_commodity, currentOrder: skuSetRankingSortOrder, rankingList: skuSetRankingReportList, delegate: self)
            }
            addShadow(cell)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // TODO: add an shadow for the cell
    func addShadow(_ cell: UICollectionViewCell) {
        // Configure the cell
        cell.contentView.layer.cornerRadius = 16.0
        cell.contentView.layer.masksToBounds = true
//        cell.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 8.0)
//        cell.layer.shadowRadius = 16.0
//        cell.layer.shadowOpacity = 1
//        cell.layer.masksToBounds = false
    }
}

extension SKURankingListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: self.frame.width-32, height: 297)
    }
}

extension SKURankingListCollectionViewCell: SKURankingCollectionViewCellDelegate {
    func switchContent(type: SKURankingReportList.sevenDaysType, order: SKURankingReport.SKURankingReportSortOrder) {
        switch type {
        case .commodity:
            self.skuRankingSortOrder = order
        case .combined_commodity:
            self.skuSetRankingSortOrder = order
        }
    }
}
