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
    @IBOutlet weak var lineChartView: LineChartView!
    var saleReportList: SaleReportList?
    override func awakeFromNib() {
        super.awakeFromNib()
        lineChartView.chartDescription?.enabled = false
        lineChartView.drawGridBackgroundEnabled = false


        let leftAxis = lineChartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMaximum = 10000
        leftAxis.axisMinimum = 0
        leftAxis.valueFormatter = self
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .pingFangTCRegular(ofSize: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = self

        lineChartView.rightAxis.enabled = false
        lineChartView.legend.form = .line
    }
    func config(with saleReportList: SaleReportList?, order: SKURankingReport.SKURankingReportSortOrder) {
        clipsToBounds = true
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.saleReportList = saleReportList
        let leftAxis = lineChartView.leftAxis
        if let reportList = saleReportList, reportList.reports.count > 0 {
            if let maximum = (order == .TOTAL_SALE_QUANTITY) ? self.saleReportList?.maximumQuantity : self.saleReportList?.maximumAmount {
                leftAxis.axisMaximum = maximum + maximum/10
            } else {
                leftAxis.axisMaximum = 10000
            }
            lineChartView.data = reportList.lineChartData(order: order)
        } else {
            leftAxis.axisMaximum = 10000
            lineChartView.data = SaleReportList.emptyLineChartData(order: order)
        }
    }
}
extension SaleReportCollectionViewCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis == lineChartView.leftAxis {
            let formatter = NumberFormatter {
                $0.numberStyle = .decimal
                $0.maximumFractionDigits = 2
            }
            return formatter.string(from: NSNumber(value: value)) ?? ""
        } else {
            if let date = lineChartView.data?.dataSets[0].entriesForXValue(value).first?.data as? Date {
                let formatter = DateFormatter {
                    $0.dateFormat = "MM-dd"
                }
                return formatter.string(from: date)
            }
        }
        return  ""
    }
}
