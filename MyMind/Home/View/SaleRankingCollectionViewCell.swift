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
    func customizeChart(dataPoints: [String], values: [Double]) {
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
        set.sliceSpace = 0
        
//        set.colors = [.systemOrange, .systemYellow, .systemRed, .systemTeal, .systemGreen, .systemGray2]
        set.colors = [
            UIColor(red: 255/255, green: 223/255, blue: 122/255, alpha: 1),
             UIColor(red: 102/255, green: 228/255, blue: 255/255, alpha: 1),
            .white.withAlphaComponent(0.8), .white.withAlphaComponent(0.6),
            .white.withAlphaComponent(0.4), .white.withAlphaComponent(0.2)
        ]

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
    private let colors: [[UIColor]] = [
        [UIColor(red: 255/255, green: 223/255, blue: 122/255, alpha: 1), UIColor(red: 255/255, green: 160/255, blue: 30/255, alpha: 1)],
        [UIColor(red: 102/255, green: 228/255, blue: 255/255, alpha: 1), UIColor(red: 39/255, green: 124/255, blue: 228/255, alpha: 1)],
        [.white.withAlphaComponent(0.8)],
        [.white.withAlphaComponent(0.6)],
        [.white.withAlphaComponent(0.4)],
        [.white.withAlphaComponent(0.2)]
    ]
    
    private weak var delegate: SaleRankingCollectionViewCellDelegate?
    private var rankingType: SaleRankingReportList.RankingType = .sale {
        didSet {
            headerView.title = rankingType.description
        }
    }
    private var devider: SaleRankingReport.SaleRankingReportDevider = .store
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
        dropDownView.tableViewBackgroundColor = .monthlyReportDropDownBg
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
    
    private var myChartView: MyMindPieChartView = {
        let view = MyMindPieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var chartView: PieChartView = {
        let view = PieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let holeBackgroundImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "sale_ranking_center_bg")
    }
    
    private let holeTextLabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCSemibold(ofSize: 18)
    }
    
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
        dropDownView.anchorView = headerView.dropDownView
        constructViewHierarchy()
        activateConstratins()
        configCollectionView()
        headerView.dropDownView.addTapGesture {
            self.dropDownView.show()
        }
        chartView.drawEntryLabelsEnabled = false
        chartView.drawHoleEnabled = true
//        if let image = UIImage(named: "sale_ranking_center_bg") {
//            chartView.holeColor = UIColor(patternImage: image)
//        }
        chartView.holeColor = UIColor(hex: "167B9F")
        chartView.drawSlicesUnderHoleEnabled = true
        chartView.holeRadiusPercent = 0.8
        chartView.legend.enabled = false
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.drawCenterTextEnabled = false
        chartView.rotationAngle = 270
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.renderer = EmptyValuePieChartRenderer(chart: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
    }
    
    // MARK: - Config
    
    func config(rankingType: SaleRankingReportList.RankingType, devider: SaleRankingReport.SaleRankingReportDevider, rankingList: SaleRankingReportList? = nil, delegate: SaleRankingCollectionViewCellDelegate? = nil) {
        self.rankingType = rankingType
        self.devider = devider
        self.headerView.alternativeInfo = devider.description
        self.delegate = delegate
        switch rankingType {
        case .sale:
            self.saleRankingReportList = rankingList?.getPieChartReports(type: rankingType)
        case .grossProfit:
            self.grossProfitRankingReportList = rankingList?.getPieChartReports(type: rankingType)
        }
        
        if let pieChatData = rankingList?.getPieChartData(type: rankingType, colors: colors) {
            myChartView.data = pieChatData
        }
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let centerText = NSMutableAttributedString(string: devider.description)
        centerText.setAttributes([.font : UIFont.pingFangTCSemibold(ofSize: 18), .paragraphStyle : paragraphStyle,
            .foregroundColor: UIColor.white], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText
//        let legend = chartView.legend
//        legend.horizontalAlignment = .right
//        legend.verticalAlignment = .center
//        legend.orientation = .vertical
//        legend.drawInside = false
//        legend.yOffset = 0
//        legend.xEntrySpace = 40
//        legend.yEntrySpace = 20
        if let rankingList = rankingList, rankingList.reports.count > 0 {
            let data = rankingList.pieChartData(profit: rankingType == .grossProfit)
            if data.entryCount > 0 {
//                legend.form = .circle
//                legend.formSize = 10
//                legend.xOffset = 0
                self.holeTextLabel.text = devider.description
                chartView.data = data
            } else {
//                legend.form = .none
//                legend.xOffset = 20
                self.holeTextLabel.text = "尚無資料"
                chartView.data = SaleRankingReportList.emptyPieChartData()
            }
        } else {
//            legend.form = .none
//            legend.xOffset = 20
            self.holeTextLabel.text = "尚無資料"
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
//        contentView.addSubview(myChartView)
        contentView.addSubview(chartView)
        contentView.addSubview(holeBackgroundImageView)
        contentView.addSubview(holeTextLabel)
        contentView.addSubview(collectionView)
    }
    
    func activateConstratins() {
        activateConstraintsBackgroundImageView()
        activateConstraintsHeaderView()
        activateConstraintsRingBackgroundImageView()
        activateConstraintsChartView()
        activateConstraintsHoleBackgroundImageView()
        activateConstraintsHoleTextLabel()
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
    
    func activateConstraintsMyChartView() {
        NSLayoutConstraint.activate([
            myChartView.centerXAnchor.constraint(equalTo: ringBackgroundImageView.centerXAnchor),
            myChartView.centerYAnchor.constraint(equalTo: ringBackgroundImageView.centerYAnchor),
            myChartView.widthAnchor.constraint(equalToConstant: 176),
            myChartView.heightAnchor.constraint(equalTo: myChartView.widthAnchor)
        ])
    }
    
    func activateConstraintsChartView() {
        NSLayoutConstraint.activate([
            chartView.centerXAnchor.constraint(equalTo: ringBackgroundImageView.centerXAnchor),
            chartView.centerYAnchor.constraint(equalTo: ringBackgroundImageView.centerYAnchor),
            chartView.widthAnchor.constraint(equalToConstant: 200),
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor)
        ])
    }
    
    func activateConstraintsHoleBackgroundImageView() {
        NSLayoutConstraint.activate([
            holeBackgroundImageView.topAnchor.constraint(equalTo: ringBackgroundImageView.topAnchor, constant: 32),
            holeBackgroundImageView.bottomAnchor.constraint(equalTo: ringBackgroundImageView.bottomAnchor, constant: -32),
            holeBackgroundImageView.leadingAnchor.constraint(equalTo: ringBackgroundImageView.leadingAnchor, constant: 32),
            holeBackgroundImageView.trailingAnchor.constraint(equalTo: ringBackgroundImageView.trailingAnchor, constant: -32)
        ])
    }
    
    func activateConstraintsHoleTextLabel() {
        NSLayoutConstraint.activate([
            holeTextLabel.centerXAnchor.constraint(equalTo: holeBackgroundImageView.centerXAnchor),
            holeTextLabel.centerYAnchor.constraint(equalTo: holeBackgroundImageView.centerYAnchor)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingItemCollectionViewCell", for: indexPath) as? SaleRankingItemCollectionViewCell else {
            return SaleRankingItemCollectionViewCell()
        }
        
        let index = indexPath.row
        let report: SaleRankingReport?
        var value: Float = 0
        
        // 取得供應商或通路商店的資料
        switch rankingType {
        case .sale:
            report = self.saleRankingReportList?.getElement(at: index)
            value = (report?.saleAmount ?? 0) / (self.saleRankingReportList?.map({$0.saleAmount}).reduce(0, +) ?? 0)
        case .grossProfit:
            report = self.grossProfitRankingReportList?.getElement(at: index)
            value = (report?.saleGrossProfit ?? 0) / (self.grossProfitRankingReportList?.map({$0.saleGrossProfit}).reduce(0, +) ?? 0)
        }
        
        if let rankingReport = report {
            cell.config(type: rankingType, devider: self.devider, report: rankingReport, value: value)
            if index < colors.count {
                cell.raningView.backgroundColor = colors.getElement(at: index)?[0]

//                switch index {
//                case 0...1:
//                    cell.raningView.addGradient(with: gradientLayer, colorSet: colors[index], direction: .topDown, layerCornerRadius: 2)
//                default:
//                    cell.raningView.backgroundColor = colors.getElement(at: index)?[0]
//                }
            }
        }
        return cell
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
