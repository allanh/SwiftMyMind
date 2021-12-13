//
//  Report+.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import SwiftUI
extension SaleReportList {
    enum SaleReportPointsType {
        case sale, cancel, returned
    }
    func points(for order: SKURankingReport.SKURankingReportSortOrder) -> [SaleReportPointsType: [CGPoint]] {
        let toDate: Date = Date().yesterday
        let fromDate: Date = toDate.thirtyDaysBefore
        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!

        var salePoints: [CGPoint] = (0..<offset).map { (i) -> CGPoint in
            return CGPoint(x: CGFloat(i), y: 0)
        }
        var canceledPoints: [CGPoint] = (0..<offset).map { (i) -> CGPoint in
            return CGPoint(x: CGFloat(i), y: 0)
        }
        var returnedPoints: [CGPoint] = (0..<offset).map { (i) -> CGPoint in
            return CGPoint(x: CGFloat(i), y: 0)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for report in reports {
            if let date = report.date {
                let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
                if let day = components.day, day < offset, day >= 0 {
                    if order == .TOTAL_SALE_AMOUNT {
                        salePoints[day].y += CGFloat(report.saleAmount)
                        canceledPoints[day].y += CGFloat(report.canceledAmount)
                        returnedPoints[day].y += CGFloat(report.returnAmount)
                    } else {
                        salePoints[day].y += CGFloat(report.saleQuantity)
                        canceledPoints[day].y += CGFloat(report.canceledQuantity)
                        returnedPoints[day].y += CGFloat(report.returnQuantity)
                    }
                }
            }
        }
        return [.sale: salePoints, .cancel: canceledPoints, .returned: returnedPoints]
    }
//    var points: [CGPoint] {
//        get {
//            let toDate: Date = Date().yesterday
//            let fromDate: Date = toDate.thirtyDaysBefore
//            let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
//            var salePoints: [CGPoint] = (0..<offset).map { (i) -> CGPoint in
//                return CGPoint(x: CGFloat(i), y: 0)
//            }
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            for report in reports {
//                if let date = report.date {
//                    let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
//                    salePoints[components.day!].y += CGFloat(report.saleAmount)
//                }
//            }
//            return salePoints
//        }
//    }
}
//extension SaleReportList {
//    func lineChartData(order: SKURankingReport.SKURankingReportSortOrder) -> LineChartData {
//        let toDate: Date = Date().yesterday
//        let fromDate: Date = toDate.thirtyDaysBefore
//        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
//        let saleEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
//        }
//        let canceledEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
//        }
//        let returnedEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        for report in reports {
//            if let date = report.date {
//                let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
//                switch order {
//                case .TOTAL_SALE_QUANTITY:
//                    saleEntries[components.day!].y += Double(report.saleQuantity)
//                    canceledEntries[components.day!].y += Double(report.canceledQuantity)
//                    returnedEntries[components.day!].y += Double(report.returnQuantity)
//                case .TOTAL_SALE_AMOUNT:
//                    saleEntries[components.day!].y += Double(report.saleAmount)
//                    canceledEntries[components.day!].y += Double(report.canceledAmount)
//                    returnedEntries[components.day!].y += Double(report.returnAmount)
//                }
//            }
//        }
//
//        let saleSet = LineChartDataSet(entries: saleEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷售數量" : "銷售總額")
//        saleSet.setColor(.systemGreen)
//        saleSet.drawCircleHoleEnabled = false
//        saleSet.drawCirclesEnabled = false
//        saleSet.drawIconsEnabled = false
//
//        let canceledSet = LineChartDataSet(entries: canceledEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "取消數量" : "取消總額")
//        canceledSet.drawCircleHoleEnabled = false
//        canceledSet.drawCirclesEnabled = false
//        canceledSet.setColor(.systemGray)
//        canceledSet.drawIconsEnabled = false
//
//
//        let returnedSet = LineChartDataSet(entries: returnedEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷退數量" : "銷退總額")
//        returnedSet.setColor(.systemOrange)
//        returnedSet.drawCirclesEnabled = false
//        returnedSet.drawCircleHoleEnabled = false
//        returnedSet.drawIconsEnabled = false
//
//        let data: LineChartData = LineChartData(dataSets: [saleSet, canceledSet, returnedSet])
//
//        return data
//    }
//    static func emptyLineChartData(order: SKURankingReport.SKURankingReportSortOrder) -> LineChartData{
//        let toDate: Date = Date()
//        let fromDate: Date = toDate.thirtyDaysBefore
//        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
//        let saleEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
//        }
//        let canceledEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
//        }
//        let returnedEntries: [ChartDataEntry] = (0..<offset).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i), y: 0, data: Calendar.current.date(byAdding: .day, value: i, to: fromDate))
//        }
//
//        let saleSet = LineChartDataSet(entries: saleEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷售數量" : "銷售總額")
//        saleSet.setColor(.systemGreen)
//        saleSet.drawCircleHoleEnabled = false
//        saleSet.drawCirclesEnabled = false
//        saleSet.drawIconsEnabled = false
//
//        let canceledSet = LineChartDataSet(entries: canceledEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "取消數量" : "取消總額")
//        canceledSet.drawCircleHoleEnabled = false
//        canceledSet.drawCirclesEnabled = false
//        canceledSet.setColor(.systemGray)
//        canceledSet.drawIconsEnabled = false
//
//
//        let returnedSet = LineChartDataSet(entries: returnedEntries, label: (order == .TOTAL_SALE_QUANTITY) ? "銷退數量" : "銷退總額")
//        returnedSet.setColor(.systemOrange)
//        returnedSet.drawCirclesEnabled = false
//        returnedSet.drawCircleHoleEnabled = false
//        returnedSet.drawIconsEnabled = false
//
//        let data: LineChartData = LineChartData(dataSets: [saleSet, canceledSet, returnedSet])
//
//        return data
//    }
//    func chartPath(width: CGFloat, height: CGFloat, maxY: CGFloat) -> Path {
//        var path = Path()
//        let heightRatio = height/maximumAmount
//        let toDate: Date = Date().yesterday
//        let fromDate: Date = toDate.thirtyDaysBefore
//        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
//        var salePoints: [CGPoint] = (0..<offset).map { (i) -> CGPoint in
//            return CGPoint(x: CGFloat(CGFloat(i)*width)+10, y: 0)
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        for report in reports {
//            if let date = report.date {
//                let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
//                salePoints[components.day!].y += CGFloat(report.saleAmount)*heightRatio
//            }
//        }
//        salePoints = salePoints.map { origin in
//            return CGPoint(x: origin.x, y: maxY - origin.y)
//        }
//        var previousPoint: CGPoint?
//        var isFirst = true
//        for index in 0..<salePoints.count {
//            let point = salePoints[index]
//            if let previousPoint = previousPoint {
//                let midPoint = CGPoint(
//                    x: (point.x + previousPoint.x) / 2,
//                    y: (point.y + previousPoint.y) / 2
//                )
//                if isFirst {
//                    path.addLine(to: midPoint)
//                    isFirst = false
//                } else if index == salePoints.count - 1{
//                    path.addQuadCurve(to: point, control: midPoint)
//                } else {
//                    path.addQuadCurve(to: midPoint, control: previousPoint)
//                }
//            }
//            else {
//                path.move(to: point)
//            }
//            previousPoint = point
//        }
//        return path
//    }
//}
