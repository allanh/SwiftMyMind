//
//  SaleRankingCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

//import UIKit
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
class SaleRankingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var myChartView: MyMindPieChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        chartView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        chartView.drawEntryLabelsEnabled = false
        chartView.drawHoleEnabled = true
        chartView.drawSlicesUnderHoleEnabled = true
        chartView.holeRadiusPercent = 0.6
        chartView.chartDescription?.enabled = true
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.drawCenterTextEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
                
        chartView.renderer = EmptyValuePieChartRenderer(chart: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
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
