//
//  SaleReportCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Charts
extension SaleReportList {
    func lineChartData(order: SKURankingReport.SKURankingReportSortOrder) -> LineChartData {
        let toDate: Date = Date().yesterday
        let fromDate: Date = toDate.thirtyDaysBefore
        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
        let saleEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
        }
        let canceledEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
        }
        let returnedEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
        }
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        for report in reports {
            if let date = report.date {
                let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
                if let day = components.day, day < offset, day >= 0 {
                    switch order {
                    case .TOTAL_SALE_QUANTITY:
                        saleEntries[day].y += Double(report.saleQuantity)
                        canceledEntries[day].y += Double(report.canceledQuantity)
                        returnedEntries[day].y += Double(report.returnQuantity)
                    case .TOTAL_SALE_AMOUNT:
                        saleEntries[day].y += Double(report.saleAmount)
                        canceledEntries[day].y += Double(report.canceledAmount)
                        returnedEntries[day].y += Double(report.returnAmount)
                    }
                }
            }
        }

        let saleSet = LineChartDataSet(entries: saleEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷售數量" : "銷售總額")
        saleSet.setColor(.systemGreen)
        saleSet.drawCircleHoleEnabled = false
        saleSet.drawCirclesEnabled = false
        saleSet.drawIconsEnabled = false

        let canceledSet = LineChartDataSet(entries: canceledEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "取消數量" : "取消總額")
        canceledSet.drawCircleHoleEnabled = false
        canceledSet.drawCirclesEnabled = false
        canceledSet.setColor(.systemGray)
        canceledSet.drawIconsEnabled = false

        
        let returnedSet = LineChartDataSet(entries: returnedEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷退數量" : "銷退總額")
        returnedSet.setColor(.systemOrange)
        returnedSet.drawCirclesEnabled = false
        returnedSet.drawCircleHoleEnabled = false
        returnedSet.drawIconsEnabled = false

        let data: LineChartData = LineChartData(dataSets: [saleSet, canceledSet, returnedSet])
        
        return data
    }
    static func emptyLineChartData(order: SKURankingReport.SKURankingReportSortOrder) -> LineChartData{
        let toDate: Date = Date()
        let fromDate: Date = toDate.thirtyDaysBefore
        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
        let saleEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
        }
        let canceledEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
        }
        let returnedEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
        }

        let saleSet = LineChartDataSet(entries: saleEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷售數量" : "銷售總額")
        saleSet.setColor(.systemGreen)
        saleSet.drawCircleHoleEnabled = false
        saleSet.drawCirclesEnabled = false
        saleSet.drawIconsEnabled = false

        let canceledSet = LineChartDataSet(entries: canceledEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "取消數量" : "取消總額")
        canceledSet.drawCircleHoleEnabled = false
        canceledSet.drawCirclesEnabled = false
        canceledSet.setColor(.systemGray)
        canceledSet.drawIconsEnabled = false

        
        let returnedSet = LineChartDataSet(entries: returnedEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷退數量" : "銷退總額")
        returnedSet.setColor(.systemOrange)
        returnedSet.drawCirclesEnabled = false
        returnedSet.drawCircleHoleEnabled = false
        returnedSet.drawIconsEnabled = false

        let data: LineChartData = LineChartData(dataSets: [saleSet, canceledSet, returnedSet])
        
        return data
    }
}

class SaleReportCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mylineChartView: MyMindLineChartView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointTypeLabel: UILabel!
    @IBOutlet weak var pointTypeButton: UIButton!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var secondDateLabel: UILabel!
    @IBOutlet weak var thirdDateLabel: UILabel!
    @IBOutlet weak var fourDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
        
    private lazy var dropDownView: DropDownView<SaleReportList.SaleReportPointsType, DataTypeDropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: SaleReportList.SaleReportPointsType.allCases) { (cell: DataTypeDropDownListTableViewCell, item) in
            self.configCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectItem(item: item)
        }
        self.configTableViewContainerView(dropDownView.tableViewContainerView)
        dropDownView.tableViewBackgroundColor = .monthlyReportDropDownBg
        dropDownView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        dropDownView.topInset = -32
        dropDownView.heightForRow = 30
        dropDownView.height = 100
        dropDownView.shouldReloadItemWhenSelect = true
        return dropDownView
    }()
    
    private lazy var quantityTypeView: SaleReportTypeView = {
        let view = SaleReportTypeView(infoType: .quantity)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var amountTypeView: SaleReportTypeView = {
        let view = SaleReportTypeView(infoType: .amount)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var saleReportList: SaleReportList?
    
    // 數量或總額
    private var currentOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            configLineChart(order: currentOrder, pointType: currentPointsType)
        }
    }
    
    // 銷售、取消或退貨
    private var currentPointsType: SaleReportList.SaleReportPointsType = .sale {
        didSet {
            configLineChart(order: currentOrder, pointType: currentPointsType)
        }
    }
    
    // line chart config
    private let gradientColors = [UIColor(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, alpha: 0.8),
                                UIColor(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, alpha: 0.5),
                                UIColor(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, alpha: 0.0)]
    private let gradientLocations = [NSNumber(value: 0), NSNumber(value: 0.3), NSNumber(value: 1)]
    private let numberFormatter = NumberFormatter {
        $0.numberStyle = .decimal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownView.anchorView = pointTypeButton
        self.dateLabel.text = "\(Date().thirtyDaysBefore.shortDateString) ~ \(Date().yesterday.shortDateString)"
        configDateLables()
        constructViewHierarchy()
        activateConstratins()
        
//        lineChartView.chartDescription?.enabled = false
//        lineChartView.drawGridBackgroundEnabled = false
//
//
//        let leftAxis = lineChartView.leftAxis
//        leftAxis.drawGridLinesEnabled = true
//        leftAxis.axisMaximum = 10000
//        leftAxis.axisMinimum = 0
//        leftAxis.valueFormatter = self
//
//        let xAxis = lineChartView.xAxis
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .pingFangTCRegular(ofSize: 10)
//        xAxis.drawGridLinesEnabled = false
//        xAxis.granularity = 1
//        xAxis.labelCount = 7
//        xAxis.valueFormatter = self
//
//        lineChartView.rightAxis.enabled = false
//        lineChartView.legend.form = .line
    }
    
    func config(with saleReportList: SaleReportList?, order: SKURankingReport.SKURankingReportSortOrder) {
        self.dateLabel.text = "\(Date().thirtyDaysBefore.shortDateString) ~ \(Date().yesterday.shortDateString)"
        configDateLables()
//        clipsToBounds = true
//        backgroundColor = .systemBackground
//        layer.cornerRadius = 16
//        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.saleReportList = saleReportList
//        let leftAxis = lineChartView.leftAxis
        configLineChart(order: .TOTAL_SALE_QUANTITY, pointType: .sale)
    }
    
    @IBAction func selectPointType(_ sender: Any) {
        dropDownView.show()
    }
    
    private func configCell(cell: DataTypeDropDownListTableViewCell,  with item: SaleReportList.SaleReportPointsType) {
        cell.titleLabel.text = item.description
        cell.titleLabel.textColor = item == currentPointsType ? .white : .white.withAlphaComponent(0.65)
        cell.backgroundColor = .clear
    }
    
    private func selectItem(item: SaleReportList.SaleReportPointsType) {
        self.currentPointsType = item
        self.pointTypeLabel.text = item.description
        dropDownView.hide()
    }
    
    private func configTableViewContainerView(_ view: UIView) {
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        view.clipsToBounds = true
    }
    
    func configLineChart(order: SKURankingReport.SKURankingReportSortOrder, pointType: SaleReportList.SaleReportPointsType) {
        if let reportList = saleReportList, reportList.reports.count > 0 {
            quantityTypeView.countLabel.text = numberFormatter.string(from: NSNumber(value: reportList.totalQuantity(pointsType: pointType))) ?? "0"
            amountTypeView.countLabel.text = numberFormatter.string(from: NSNumber(value: reportList.totalAmount(pointsType: pointType))) ?? "0"
            mylineChartView.data = MyMindLineChartData(points: reportList.points(for: order)[pointType] ?? [],
                                                       gradientColors: gradientColors,
                                                       gradientLocations: gradientLocations)
        } else {
            quantityTypeView.countLabel.text = "-"
            amountTypeView.countLabel.text = "-"
            mylineChartView.data = MyMindLineChartData.empty
        }
    }

    func configDateLables() {
        let labels: [UILabel] = [startDateLabel, secondDateLabel, thirdDateLabel, fourDateLabel, endDateLabel]
        let startDate = Date().thirtyDaysBefore
        for (index, element) in labels.enumerated() {
            element.text = Calendar.current.date(byAdding: .day, value: index*7, to: startDate)?.getFormattedDate("MM-dd")
        }
    }
}

extension SaleReportCollectionViewCell {
    func constructViewHierarchy() {
        contentView.addSubview(quantityTypeView)
        contentView.addSubview(amountTypeView)
        quantityTypeView.addTapGesture {
            self.quantityTypeView.onSelected()
            self.amountTypeView.onNotSelected()
            self.currentOrder = .TOTAL_SALE_QUANTITY
        }
        amountTypeView.addTapGesture {
            self.quantityTypeView.onNotSelected()
            self.amountTypeView.onSelected()
            self.currentOrder = .TOTAL_SALE_AMOUNT
        }
    }
    
    func activateConstratins() {
        activateConstraintsQuantityTypeView()
        activateConstraintsAmountTypeView()
    }
    
    func activateConstraintsQuantityTypeView() {
        NSLayoutConstraint.activate([
            quantityTypeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quantityTypeView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            quantityTypeView.bottomAnchor.constraint(equalTo: mylineChartView.topAnchor, constant: -6),
            quantityTypeView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4422)
        ])
    }

    func activateConstraintsAmountTypeView() {
        NSLayoutConstraint.activate([
            amountTypeView.leadingAnchor.constraint(equalTo: quantityTypeView.trailingAnchor, constant: 8),
            amountTypeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountTypeView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            amountTypeView.bottomAnchor.constraint(equalTo: mylineChartView.topAnchor, constant: -6),
            amountTypeView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4422)
        ])
    }
}

//extension SaleReportCollectionViewCell: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        if axis == lineChartView.leftAxis {
//            let formatter = NumberFormatter {
//                $0.numberStyle = .decimal
//                $0.maximumFractionDigits = 2
//            }
//            return formatter.string(from: NSNumber(value: value)) ?? ""
//        } else {
//            if let date = lineChartView.data?.dataSets[0].entriesForXValue(value).first?.data as? Date {
//                let formatter = DateFormatter {
//                    $0.dateFormat = "MM-dd"
//                }
//                return formatter.string(from: date)
//            }
//        }
//        return  ""
//    }
//}
