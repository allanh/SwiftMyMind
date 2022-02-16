//
//  rankingListCollectionViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/21.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SaleRankingListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    @IBOutlet weak var rankingListCollectionView: UICollectionView!
    @IBOutlet weak var pageDot: UIPageControl!
    private weak var delegate: RankingListCollectionViewCellDelegate?
    
    private var amountRankingDevider: SaleRankingReport.SaleRankingReportDevider = .store {
        didSet {
            loadSaleRankingReportList()
        }
    }
    
    private var grossProfitRankingDevider: SaleRankingReport.SaleRankingReportDevider = .store {
        didSet {
            loadGrossProfitRankingReportList()
        }
    }
    
    private var saleRankingReportList: SaleRankingReportList? {
        didSet {
            rankingListCollectionView.reloadSections([SaleRankingReportList.RankingType.sale.rawValue])
        }
    }
    
    private var grossProfitRankingReportList: SaleRankingReportList? {
        didSet {
            rankingListCollectionView.reloadSections([SaleRankingReportList.RankingType.grossProfit.rawValue])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rankingListCollectionView.dataSource = self
        rankingListCollectionView.delegate = self
        contentView.backgroundColor = .clear
        if let layout = rankingListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
//            layout.minimumLineSpacing = 15
//            layout.minimumInteritemSpacing = 0
            rankingListCollectionView.collectionViewLayout = layout
        }
    }
    
    func config(delegate: RankingListCollectionViewCellDelegate? = nil) {
        self.delegate = delegate
        loadSaleRankingReportList()
        loadGrossProfitRankingReportList()
    }
    
    // 取得銷售金額佔比列表
    private func loadSaleRankingReportList() {
        self.delegate?.showLoading(true)
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        if amountRankingDevider == .store {
            dashboardLoader.storeRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "TOTAL_SALE_AMOUNT")
                .done { saleRankingReportList in
                    self.saleRankingReportList = saleRankingReportList
                }
                .ensure {
                    self.delegate?.showLoading(false)
                }
                .catch { error in
                    self.saleRankingReportList = nil
                    self.delegate?.handlerCellError(error)
                }
        } else {
            dashboardLoader.vendorRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "TOTAL_SALE_AMOUNT")
                .done { saleRankingReportList in
                    self.saleRankingReportList = saleRankingReportList
                }
                .ensure {
                    self.delegate?.showLoading(false)
                }
                .catch { error in
                    self.saleRankingReportList = nil
                    self.delegate?.handlerCellError(error)
                }
        }
    }
    
    // 取得銷售毛利佔比列表
    private func loadGrossProfitRankingReportList() {
        self.delegate?.showLoading(true)
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        if grossProfitRankingDevider == .store {
            dashboardLoader.storeRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "SALE_GROSS_PROFIT")
                .done { grossProfitRankingReportList in
                    self.grossProfitRankingReportList = grossProfitRankingReportList
                }
                .ensure {
                    self.delegate?.showLoading(false)
                }
                .catch { error in
                    self.grossProfitRankingReportList = nil
                    self.delegate?.handlerCellError(error)
                }
        } else {
            dashboardLoader.vendorRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "SALE_GROSS_PROFIT")
                .done { grossProfitRankingReportList in
                    self.grossProfitRankingReportList = grossProfitRankingReportList
                }
                .ensure {
                    self.delegate?.showLoading(false)
                }
                .catch { error in
                    self.grossProfitRankingReportList = nil
                    self.delegate?.handlerCellError(error)
                }
        }
    }
}

extension SaleRankingListCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SaleRankingReportList.RankingType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case SaleRankingReportList.RankingType.sale.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingCollectionViewCell", for: indexPath) as? SaleRankingCollectionViewCell {
                cell.backgroundColor = .clear
                cell.config(rankingType: .sale, devider: amountRankingDevider, rankingList: saleRankingReportList, delegate: self)
                addShadow(cell)
                return cell
            }
            return UICollectionViewCell()

        case SaleRankingReportList.RankingType.grossProfit.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingCollectionViewCell", for: indexPath) as? SaleRankingCollectionViewCell {
                cell.backgroundColor = .clear
                cell.config(rankingType: .grossProfit, devider: grossProfitRankingDevider, rankingList: grossProfitRankingReportList, delegate: self)
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageDot.currentPage = Int(
//            (rankingListCollectionView.contentOffset.x / rankingListCollectionView.frame.width)
//                .rounded(.toNearestOrAwayFromZero)
//            )
//        )
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageDot?.currentPage = Int(roundedIndex)
    }
}

extension SaleRankingListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: self.frame.width-32, height: 498)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case SaleRankingReportList.RankingType.sale.rawValue:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 8.0)
        case SaleRankingReportList.RankingType.grossProfit.rawValue:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 16.0)
        default:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0)
        }
    }
}

extension SaleRankingListCollectionViewCell: SaleRankingCollectionViewCellDelegate {
    func switchContent(type: SaleRankingReportList.RankingType, devider: SaleRankingReport.SaleRankingReportDevider) {
        switch type {
        case .sale:
            self.amountRankingDevider = devider
        case .grossProfit:
            self.grossProfitRankingDevider = devider
        }
    }
}
