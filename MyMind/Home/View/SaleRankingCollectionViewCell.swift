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
                amount += report.saleAmount
            }
            return amount
        }
    }
    var totalGrossProfit: Float {
        get {
            var grossProfit: Float = 0
            for report in reports {
                grossProfit += report.saleGrossProfit
            }
            return grossProfit
        }
    }
    func pieChartData(maximum: Int = 5) -> PieChartData {
        var pieChartEntries: [PieChartDataEntry] = []
        let formatter = NumberFormatter {
            $0.numberStyle = .percent
            $0.maximumFractionDigits = 2
            $0.minimumFractionDigits = 2
        }
        for report in reports {
            let amount: Double = Double(report.saleAmount)/Double(totalSaleAmount)
            let string: String = formatter.string(from: NSNumber(value: amount)) ?? ""
            pieChartEntries.append(PieChartDataEntry(value:amount, label: report.name+" "+string))
        }
        var value: Double = 0
        if pieChartEntries.count > maximum {
            for (index, entry) in pieChartEntries.enumerated() {
                if index < maximum-1 {
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
}
class SaleRankingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var chartView: PieChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        chartView.drawEntryLabelsEnabled = false
        chartView.drawHoleEnabled = true
        chartView.drawSlicesUnderHoleEnabled = true
        chartView.holeRadiusPercent = 0.6
        chartView.chartDescription?.enabled = true
        chartView.setExtraOffsets(left: -100, top: 0, right: 100, bottom: 0)
        chartView.drawCenterTextEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.form = .circle
        l.formSize = 10
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 40
        l.yEntrySpace = 20
        l.yOffset = 10
        l.xOffset = 0
        
        chartView.renderer = EmptyValuePieChartRenderer(chart: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
    }
    func config(with rankingList: SaleRankingReportList?, devider: SaleRankingReport.SaleRankingReportDevider) {
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
        chartView.data = rankingList?.pieChartData()

    }
}
