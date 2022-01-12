//
//  SaleRankingCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import Charts

class EmptyValuePieChartRenderer: PieChartRenderer {
    override func drawValues(context: CGContext) {
        
    }
}
extension SaleRankingReportList {
    var totalSaleAmount: Float {
        get {
            var amount: Float = 0
            for report in reports {
                if report.saleAmount > 0 {
                    amount += report.saleAmount
                }
            }
            return amount > 0 ? amount : 1
        }
    }
    var totalGrossProfit: Float {
        get {
            var grossProfit: Float = 0
            for report in reports {
                if report.saleGrossProfit > 0 {
                    grossProfit += report.saleGrossProfit
                }
            }
            return grossProfit > 0 ? grossProfit : 1
        }
    }
    func pieChartData(maximum: Int = 5, profit: Bool = false) -> PieChartData {
        var pieChartEntries: [PieChartDataEntry] = []
        let formatter = NumberFormatter {
            $0.numberStyle = .percent
            $0.maximumFractionDigits = 2
            $0.minimumFractionDigits = 2
        }
        for report in reports {
            let amount: Double = profit ? Double(report.saleGrossProfit)/Double(totalGrossProfit) : Double(report.saleAmount)/Double(totalSaleAmount)
            if amount > 0 {
                let string: String = formatter.string(from: NSNumber(value: amount)) ?? ""
                pieChartEntries.append(PieChartDataEntry(value:amount, label: report.name+" "+string))
            }
        }
        var value: Double = 0
        if pieChartEntries.count > maximum {
            for (index, entry) in pieChartEntries.enumerated() {
                if index < maximum {
                    continue
                }
                value += entry.value
            }
            pieChartEntries.removeSubrange((maximum)..<pieChartEntries.count)
            let string: String = formatter.string(from: NSNumber(value: value)) ?? ""
            pieChartEntries.append(PieChartDataEntry(value: value, label: "其他"+" "+string))
        }
        let set = PieChartDataSet(entries: pieChartEntries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [.systemOrange, .systemYellow, .systemRed, .systemTeal, .systemGreen, .systemGray2]
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        return data
    }
    static func emptyPieChartData(maximum: Int = 5) -> PieChartData {
        let pieChartEntries: [PieChartDataEntry] = [PieChartDataEntry(value:100, label: "尚無資料")]
        let set = PieChartDataSet(entries: pieChartEntries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [.tertiaryLabel]
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        return data
    }
}


protocol SaleRankingCollectionViewCellDelegate: AnyObject {
    func switchContent(type: SaleRankingReportList.RankingType, devider: SaleRankingReport.SaleRankingReportDevider)
}

class SaleRankingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    private weak var delegate: SaleRankingCollectionViewCellDelegate?
    private var rankingType: SaleRankingReportList.RankingType = .sale {
        didSet {
            headerView.title = rankingType.description
        }
    }
    private var devider: SaleRankingReport.SaleRankingReportDevider = .store
//    private var saleRankingReportList: SaleRankingReportList? {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//    private var grossProfitRankingReportList: SaleRankingReportList? {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    private var saleRankingReportList: [SaleRankingReport]? {
        didSet {
            collectionView.reloadData()
        }
    }
    private var grossProfitRankingReportList: [SaleRankingReport]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: UI

    private lazy var dropDownView: DropDownView<SaleRankingReport.SaleRankingReportDevider, DataTypeDropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: SaleRankingReport.SaleRankingReportDevider.allCases) { (cell: DataTypeDropDownListTableViewCell, item) in
            self.configCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectItem(item: item)
        }
        self.configTableViewContainerView(dropDownView.tableViewContainerView)
        dropDownView.tableViewBackgroundColor = .prussianBlue
        dropDownView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        dropDownView.showScrollBar = false
        dropDownView.topInset = -32
        dropDownView.heightForRow = 32
        dropDownView.height = 76
        dropDownView.shouldReloadItemWhenSelect = true
        return dropDownView
    }()
    
    private lazy var headerView: DropDownHeaderView = {
        let date = "\(Date().sevenDaysBefore.shortDateString) ~ \(Date().yesterday.shortDateString)"
        let view = DropDownHeaderView(frame: .zero,
                                      title: "近7日銷售金額佔比",
                                      alternativeInfo: "通路商店",
                                      date: date
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "sale_ranking_bg")
    }
    
    private let ringBackgroundImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "sale_ranking_ring_bg")
    }
    
    private let rankingLabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCSemibold(ofSize: 18)
    }
    
    private var chartView: PieChartView!
    private var myChartView: MyMindPieChartView = {
        let view = MyMindPieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(SaleRankingItemCollectionViewCell.self, forCellWithReuseIdentifier: "SaleRankingItemCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownView.anchorView = headerView.alternativeInfoView
        constructViewHierarchy()
        activateConstratins()
        configCollectionView()
        headerView.alternativeInfoView.addTapGesture {
            self.dropDownView.show()
        }
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        chartView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        chartView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        chartView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
////        chartView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        chartView.drawEntryLabelsEnabled = false
//        chartView.drawHoleEnabled = true
//        chartView.drawSlicesUnderHoleEnabled = true
//        chartView.holeRadiusPercent = 0.6
//        chartView.chartDescription?.enabled = true
//        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
//        chartView.drawCenterTextEnabled = true
//        chartView.rotationAngle = 0
//        chartView.rotationEnabled = true
//        chartView.highlightPerTapEnabled = true
//
//        chartView.renderer = EmptyValuePieChartRenderer(chart: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
    }
    
    // MARK: - Config
    
    func config(rankingType: SaleRankingReportList.RankingType, devider: SaleRankingReport.SaleRankingReportDevider, rankingList: SaleRankingReportList? = nil, delegate: SaleRankingCollectionViewCellDelegate? = nil) {
        self.rankingType = rankingType
        self.devider = devider
        self.headerView.alternativeInfo = devider.description
        self.rankingLabel.text = devider.description
        self.delegate = delegate
        switch rankingType {
        case .sale:
            self.saleRankingReportList = rankingList?.getPieChartReports(type: rankingType)
        case .grossProfit:
            self.grossProfitRankingReportList = rankingList?.getPieChartReports(type: rankingType)
        }
        myChartView.data = MyMindPieChartData.mock
    }
    
    func config(with rankingList: SaleRankingReportList?, devider: SaleRankingReport.SaleRankingReportDevider, profit: Bool) {
        clipsToBounds = true
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let centerText = NSMutableAttributedString(string: devider.description)
        centerText.setAttributes([.font : UIFont.pingFangTCRegular(ofSize: 13),
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText
        let legend = chartView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .center
        legend.orientation = .vertical
        legend.drawInside = false
        legend.yOffset = 0
        legend.xEntrySpace = 40
        legend.yEntrySpace = 20
        if let rankingList = rankingList, rankingList.reports.count > 0 {
            let data = rankingList.pieChartData(profit: profit)
            if data.entryCount > 0 {
                legend.form = .circle
                legend.formSize = 10
                legend.xOffset = 0
                chartView.data = data
            } else {
                legend.form = .none
                legend.xOffset = 20
                chartView.data = SaleRankingReportList.emptyPieChartData()
            }
        } else {
            legend.form = .none
            legend.xOffset = 20
            chartView.data = SaleRankingReportList.emptyPieChartData()
        }
    }
}

// MARK: - Drop down view

extension SaleRankingCollectionViewCell {
    private func configCell(cell: DataTypeDropDownListTableViewCell,  with item: SaleRankingReport.SaleRankingReportDevider) {
        cell.titleLabel.text = item.description
        cell.titleLabel.textColor = item == devider ? .white : .white.withAlphaComponent(0.65)
        cell.backgroundColor = .clear
    }

    private func selectItem(item: SaleRankingReport.SaleRankingReportDevider) {
        delegate?.switchContent(type: rankingType, devider: item)
        dropDownView.hide()
    }

    private func configTableViewContainerView(_ view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 0
        view.clipsToBounds = true
    }
}

// MARK: - Constructs

extension SaleRankingCollectionViewCell {
    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func constructViewHierarchy() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(headerView)
        contentView.addSubview(ringBackgroundImageView)
        contentView.addSubview(myChartView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(collectionView)
    }
    
    func activateConstratins() {
        activateConstraintsBackgroundImageView()
        activateConstraintsHeaderView()
        activateConstraintsRingBackgroundImageView()
        activateConstraintsChartView()
        activateConstraintsRankingLabel()
        activateConstraintsCollectionView()
    }
    
    func activateConstraintsBackgroundImageView() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func activateConstraintsHeaderView() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func activateConstraintsRingBackgroundImageView() {
        NSLayoutConstraint.activate([
            ringBackgroundImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ringBackgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 102),
            ringBackgroundImageView.widthAnchor.constraint(equalToConstant: 200),
            ringBackgroundImageView.heightAnchor.constraint(equalTo: ringBackgroundImageView.widthAnchor)
        ])
    }
    
    func activateConstraintsChartView() {
        NSLayoutConstraint.activate([
            myChartView.centerXAnchor.constraint(equalTo: ringBackgroundImageView.centerXAnchor),
            myChartView.centerYAnchor.constraint(equalTo: ringBackgroundImageView.centerYAnchor),
            myChartView.widthAnchor.constraint(equalToConstant: 176),
            myChartView.heightAnchor.constraint(equalTo: myChartView.widthAnchor)
        ])
    }
    
    func activateConstraintsRankingLabel() {
        NSLayoutConstraint.activate([
            rankingLabel.centerXAnchor.constraint(equalTo: ringBackgroundImageView.centerXAnchor),
            rankingLabel.centerYAnchor.constraint(equalTo: ringBackgroundImageView.centerYAnchor)
        ])
    }
    
    func activateConstraintsCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: ringBackgroundImageView.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -23)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension SaleRankingCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch rankingType {
        case .sale:
            return self.saleRankingReportList?.count ?? 0
        case .grossProfit:
            return self.grossProfitRankingReportList?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingItemCollectionViewCell", for: indexPath) as? SaleRankingItemCollectionViewCell
        let report: SaleRankingReport?
        switch rankingType {
        case .sale:
            report = self.saleRankingReportList?.getElement(at: indexPath.row)
        case .grossProfit:
            report = self.grossProfitRankingReportList?.getElement(at: indexPath.row)
        }
        if let rankingReport = report {
            cell?.config(type: rankingType, index: indexPath.row, report: rankingReport)
        }
        return cell ?? SaleRankingItemCollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SaleRankingCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 4.0, bottom: 8.0, right: 4.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 8, height: 41)
    }
}
