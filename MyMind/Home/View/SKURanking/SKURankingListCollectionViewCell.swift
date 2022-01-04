//
//  SKURankingListCollectionViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/21.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

protocol RankingListCollectionViewCellDelegate: AnyObject {
    func showLoading(_ isNetworkProcessing: Bool)
    func handlerCellError(_ error: Error)
}

class SKURankingListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var skuRankingListCollectionView: UICollectionView!
    @IBOutlet weak var pageDot: UIPageControl!
    private weak var delegate: RankingListCollectionViewCellDelegate?
    
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
            skuRankingListCollectionView.reloadSections([SKURankingReportList.sevenDaysType.commodity.rawValue])
        }
    }
    private var skuSetRankingReportList: SKURankingReportList? {
        didSet {
            skuRankingListCollectionView.reloadSections([SKURankingReportList.sevenDaysType.combined_commodity.rawValue])
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
    
    func config(delegate: RankingListCollectionViewCellDelegate? = nil) {
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SKURankingReportList.sevenDaysType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case SKURankingReportList.sevenDaysType.commodity.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
                cell.backgroundColor = .clear
                    cell.config(type: .commodity, currentOrder: skuRankingSortOrder, rankingList: skuRankingReportList, delegate: self)
                addShadow(cell)
                return cell
            }
            return UICollectionViewCell()
            
        case SKURankingReportList.sevenDaysType.combined_commodity.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
                cell.backgroundColor = .clear
                cell.config(type: .combined_commodity, currentOrder: skuSetRankingSortOrder, rankingList: skuSetRankingReportList, delegate: self)
                addShadow(cell)
                return cell
            }
            return UICollectionViewCell()
            
        default:
            return UICollectionViewCell()
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageDot?.currentPage = Int(roundedIndex)
    }
}

extension SKURankingListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: self.frame.width-32, height: 297)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case SKURankingReportList.sevenDaysType.commodity.rawValue:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 8.0)
        case SKURankingReportList.sevenDaysType.combined_commodity.rawValue:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 16.0)
        default:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0)
        }
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
