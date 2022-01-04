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
    func switchContent(type: SaleRankingCollectionViewCell.RankingType, devider: SaleRankingReport.SaleRankingReportDevider)
}

class SaleRankingCollectionViewCell: UICollectionViewCell {
    
    enum RankingType: Int, CaseIterable {
        case sale = 0
        case grossProfit
        
        var description: String {
            get {
                switch self {
                case .sale:
                    return "近7日銷售金額佔比"
                case .grossProfit:
                    return "近7日銷售毛利佔比"
                }
            }
        }
    }
    
    private weak var delegate: SaleRankingCollectionViewCellDelegate?
    private var rankingType: RankingType = .sale {
        didSet {
            headerView.title = rankingType.description
        }
    }
    private var devider: SaleRankingReport.SaleRankingReportDevider = .store
    private var saleRankingReportList: SaleRankingReportList?
    private var grossProfitRankingReportList: SaleRankingReportList?
    
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
        view.alternativeInfoViewBackgroundColor = .prussianBlue
        view.titleTextColor = .prussianBlue
        view.dateTextColor = .brownGrey2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "sale_ranking_bg")
    }
    
    weak var chartView: PieChartView!
    weak var myChartView: MyMindPieChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownView.anchorView = headerView.alternativeInfoView
        constructViewHierarchy()
        activateConstratins()
        configTableView()
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
    
    func config(rankingType: RankingType, devider: SaleRankingReport.SaleRankingReportDevider, rankingList: SaleRankingReportList? = nil, delegate: SaleRankingCollectionViewCellDelegate? = nil) {
        self.rankingType = rankingType
        self.devider = devider
        self.headerView.alternativeInfo = devider.description
        self.delegate = delegate
        switch rankingType {
        case .sale:
            self.saleRankingReportList = rankingList
        case .grossProfit:
            self.grossProfitRankingReportList = rankingList
        }
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
        myChartView.data = MyMindPieChartData.mock
    }
}

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

extension SaleRankingCollectionViewCell {
    private func configTableView() {
//        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.registerCell(SKURankingTableViewCell.self)
    }
    
    func constructViewHierarchy() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(headerView)
//        contentView.addSubview(tableView)
    }
    
    func activateConstratins() {
        activateConstraintsBackgroundImageView()
        activateConstraintsHeaderView()
//        activateConstraintsTableView()
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
    
//    func activateConstraintsTableView() {
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 13),
//            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
//        ])
//    }
}
