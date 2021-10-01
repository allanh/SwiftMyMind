//
//  MyMind_Widgets.swift
//  MyMind Widgets
//
//  Created by Nelson Chan on 2021/9/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import WidgetKit
import SwiftUI
import Charts
/// value formatter
//class LineChartLeftAxisValueFormatter: IAxisValueFormatter {
//    static let shared: LineChartLeftAxisValueFormatter = .init()
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        return formatter.string(from: NSNumber(value: value)) ?? ""
//    }
//}
//class LineChartBottomAxisValueFormatter: IAxisValueFormatter {
//    static let shared: LineChartBottomAxisValueFormatter = .init()
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd"
//        return formatter.string(from: date)
//    }
//}
/// extension
//extension UIView {
//    var image: UIImage? {
//        get {
//            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
//            defer { UIGraphicsEndImageContext() }
//            if let context = UIGraphicsGetCurrentContext() {
//                layer.render(in: context)
//                let image = UIGraphicsGetImageFromCurrentImageContext()
//                return image
//            }
//            return nil
//        }
//    }
//}
//extension LineChartView {
//    convenience init(frame: CGRect, entry: Provider.Entry) {
//        self.init(frame: frame)
//        self.backgroundColor = .white
//        self.drawGridBackgroundEnabled = false
//        self.chartDescription?.enabled = false
//
//        let leftAxis = self.leftAxis
//        leftAxis.drawGridLinesEnabled = true
//        leftAxis.axisMaximum = 10000
//        leftAxis.axisMinimum = 0
//        leftAxis.valueFormatter = LineChartLeftAxisValueFormatter.shared
//
//        let xAxis = self.xAxis
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .pingFangTCRegular(ofSize: 10)
//        xAxis.drawGridLinesEnabled = false
//        xAxis.granularity = 1
//        xAxis.labelCount = 7
//        xAxis.valueFormatter = LineChartBottomAxisValueFormatter.shared
//
//        self.rightAxis.enabled = false
//        self.legend.form = .line
//        if let reportList = entry.reportList, reportList.reports.count > 0 {
//            let maximum = reportList.maximumAmount
//            leftAxis.axisMaximum = maximum + maximum/10
//            self.data = reportList.lineChartData(order: SKURankingReport.SKURankingReportSortOrder.TOTAL_SALE_AMOUNT)
//        } else {
//            leftAxis.axisMaximum = 10000
//            self.data = SaleReportList.emptyLineChartData(order: SKURankingReport.SKURankingReportSortOrder.TOTAL_SALE_AMOUNT)
//        }
//    }
//}
/// widget
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MyMindEntry {
        MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, points: [], toDoCount: nil, announcementCount: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (MyMindEntry) -> ()) {
        let entry = MyMindEntry(date: Date(), isLogin: true, maximumAmount: 100, totalAmount: 1280, points: [CGPoint(x: 0, y: 20), CGPoint(x: 1, y: 25), CGPoint(x: 2, y: 30), CGPoint(x: 3, y: 40), CGPoint(x: 4, y: 60), CGPoint(x: 5, y: 85), CGPoint(x: 6, y: 75), CGPoint(x: 7, y: 40), CGPoint(x: 8, y: 70), CGPoint(x: 9, y: 20), CGPoint(x: 10, y: 30), CGPoint(x: 11, y: 45), CGPoint(x: 12, y: 50), CGPoint(x: 13, y: 45), CGPoint(x: 14, y: 50), CGPoint(x: 15, y: 45), CGPoint(x: 16, y: 45), CGPoint(x: 17, y: 30), CGPoint(x: 18, y: 20), CGPoint(x: 19, y: 60), CGPoint(x: 20, y: 80), CGPoint(x: 21, y: 100), CGPoint(x: 22, y: 90), CGPoint(x: 23, y: 80), CGPoint(x: 24, y: 70), CGPoint(x: 25, y: 70), CGPoint(x: 26, y: 75), CGPoint(x: 27, y: 75), CGPoint(x: 28, y: 70), CGPoint(x: 29, y: 70)], toDoCount: 198, announcementCount: 7)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MyMindEntry>) -> ()) {
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        NetworkManager.shared.authorization { authorization, success in
            if success {
                NetworkManager.shared.saleReportList { reportList in
                    NetworkManager.shared.toDoCount(with: authorization?.navigations.description ?? "") { toDoCount in
                        NetworkManager.shared.announcementCount { announcementCount in
                            let entry = MyMindEntry(date: Date(), isLogin: true, maximumAmount: reportList?.maximumAmount ?? 1, totalAmount: reportList?.totalSaleAmount ?? 0,  points: reportList?.points ?? [], toDoCount: toDoCount, announcementCount: announcementCount)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            } else {
                let entry = MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, points: [], toDoCount: nil, announcementCount: nil)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            }
        }
    }
}
/// MyMindEntry
struct MyMindEntry: TimelineEntry {
    let date: Date
    let isLogin: Bool
    let maximumAmount: CGFloat
    let totalAmount: CGFloat
    let points: [CGPoint]
    let toDoCount: Int?
    let announcementCount: Int?
    func path(with frame: CGRect) -> Path {
        var path = Path()
        let heightRatio: CGFloat = frame.size.height/maximumAmount
        let itemWidth = frame.size.width/CGFloat((points.count > 1) ? points.count - 1 : 1)
        let drawPoints = points.map { origin in
            return CGPoint(x: (origin.x*itemWidth), y: frame.maxY - (origin.y*heightRatio))
        }
        var previousPoint: CGPoint?
        var isFirst = true
        for index in 0..<drawPoints.count {
            let point = drawPoints[index]
            if let previousPoint = previousPoint {
                let midPoint = CGPoint(
                    x: (point.x + previousPoint.x) / 2,
                    y: (point.y + previousPoint.y) / 2
                )
                if isFirst {
                    path.addLine(to: midPoint)
                    isFirst = false
                } else if index == drawPoints.count - 1{
                    path.addQuadCurve(to: point, control: midPoint)
                } else {
                    path.addQuadCurve(to: midPoint, control: previousPoint)
                }
            }
            else {
                path.move(to: point)
            }
            previousPoint = point
        }
        return path
    }
    func closePath(with frame: CGRect) -> Path {
        var path = Path()
        let heightRatio: CGFloat = frame.size.height/maximumAmount
        let itemWidth = frame.size.width/CGFloat((points.count > 1) ? points.count - 1 : 1)
        let drawPoints = points.map { origin in
            return CGPoint(x: (origin.x*itemWidth), y: frame.maxY - (origin.y*heightRatio))
        }
        var previousPoint: CGPoint?
        var isFirst = true
        for index in 0..<drawPoints.count {
            let point = drawPoints[index]
            if let previousPoint = previousPoint {
                let midPoint = CGPoint(
                    x: (point.x + previousPoint.x) / 2,
                    y: (point.y + previousPoint.y) / 2
                )
                if isFirst {
                    path.addLine(to: midPoint)
                    isFirst = false
                } else if index == drawPoints.count - 1{
                    path.addQuadCurve(to: point, control: midPoint)
                } else {
                    path.addQuadCurve(to: midPoint, control: previousPoint)
                }
            }
            else {
                if point.y != frame.maxY {
                    path.move(to: CGPoint(x: frame.minX, y: frame.maxY))
                    path.addLine(to: point)
                } else {
                    path.move(to: point)
                }
            }
            previousPoint = point
        }
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
        return path
    }
}
/// Entry View
struct MyMind_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
//    lazy var view = LineChartView(frame: CGRect(x: 0, y: 0, width: 320, height: 180), entry: entry)
//    func viewValue() -> some UIView {
//        var mutatableSelf = self
//        return mutatableSelf.view
//    }

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            HStack {
                if entry.isLogin {
                    Spacer()
                    IconView(iconName: "todo", background: [Color(red: 151.0/255.0, green: 125.0/255.0, blue: 240.0/255.0), Color(red: 116.0/255.0, green: 97.0/255.0, blue: 240.0/255.0)], title: "代辦事項", value: entry.toDoCount == nil ? nil : "\(entry.toDoCount!)")
                        .blendMode(.sourceAtop)
                    IconView(iconName: "announcement", background: [Color(red: 255.0/255.0, green: 97.0/255.0, blue: 97.0/255.0), Color(red: 239.0/255.0, green: 29.0/255.0, blue: 98.0/255.0)], title: "公告通知", value: entry.announcementCount == nil ? nil : "\(entry.announcementCount!)")
                        .blendMode(.sourceAtop)
                    IconView(iconName: "otp", background: [Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0), Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0)], title: "MyMind", value: "OTP")
                        .blendMode(.sourceAtop)
                    Spacer()
                } else {
                    Spacer()
                    LoginView()
                        .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                        .blendMode(.sourceAtop)
                    IconView(iconName: "otp", background: [Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0), Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0)], title: "MyMind", value: "OTP")
                        .blendMode(.sourceAtop)
                    Spacer()

                }
            }
            .padding(.top)
            .padding(.bottom)
            .background(LinearGradient(colors: [Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0), .black], startPoint: .top, endPoint: .bottom))
            .blendMode(.darken)
        case .systemLarge:
            VStack {
                Spacer()
                HStack {
                    if entry.points.count > 1 {
                        Text("近30日銷售數據")
                            .frame(height: 24, alignment: .topLeading)
                            .font(.custom("PingFangTC-Regular", size: 12))
                            .foregroundColor(Color(white: 1.0, opacity: 0.65))
                            .padding(.leading, 16)
                            .padding(.top, 20)
                            .blendMode(.sourceAtop)
                    }
                    Spacer()
                    Text("MyMind")
                        .frame(height: 24, alignment: .topTrailing)
                        .font(.custom("PingFangTC-Semibold", size: 12))
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                        .padding(.top, 20)
                        .blendMode(.sourceAtop)
                }
                Spacer()
                if entry.isLogin {
                    VStack(alignment: .leading) {
                        Text(String(format: "%.2f", entry.totalAmount))
                            .font(.custom("PingFangTC-Semibold", size: 24))
                            .foregroundColor(.white)
                            .blendMode(.sourceAtop)
                        ChartView(entry: entry)
                            .blendMode(.sourceAtop)
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                } else {
                    LoginView()
                        .frame(maxHeight: .infinity)
                        .blendMode(.sourceAtop)
                }
                Spacer(minLength: 20)
                HStack {
                    IndicatorView(count: entry.toDoCount, title: "代辦事項", colors: [Color(red: 139.0/255.0, green: 134.0/255.0, blue: 196.0/255.0), Color(red: 112.0/255.0, green: 107.0/255.0, blue: 178.0/255.0)])
                        .frame(maxWidth: .infinity)
                        .blendMode(.sourceAtop)
                    Spacer()
                    IndicatorView(count: entry.announcementCount, title: "公告通知", colors: [Color(red: 195.0/255.0, green: 117.0/255.0, blue: 121.0/255.0), Color(red: 160.0/255.0, green: 75.0/255.0, blue: 99.0/255.0)])
                        .frame(maxWidth: .infinity)
                        .blendMode(.sourceAtop)
                    Spacer()
                    Link(destination: URL(string: "mymindwidget://otp")!) {
                        HStack {
                            Image("otp")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                            Text("OTP")
                                .font(.custom("PingFangTC-Semibold", size: 24))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0))
                        .cornerRadius(16)
                        .blendMode(.sourceAtop)
                    }
                }
                .frame(height: 48)
                .padding(.trailing, 16)
                .padding(.leading, 16)
                .padding(.bottom, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [Color(red: 0.0/255.0, green: 68.0/255.0, blue: 119.0/255.0), .black], startPoint: .top, endPoint: .bottom))
            .blendMode(.darken)
        default:
            Text("not available")
        }
    }
}
@main
struct MyMind_Widgets: Widget {
    let kind: String = "MyMind_Widgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyMind_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("MyMind")
        .description("Show MyMind Important Infos.")
        .supportedFamilies([.systemLarge, .systemMedium])
    }
}

struct MyMind_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, points: [], toDoCount: 20, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, points: [], toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, maximumAmount: 100, totalAmount: 1280, points: [CGPoint(x: 0, y: 20), CGPoint(x: 1, y: 25), CGPoint(x: 2, y: 30), CGPoint(x: 3, y: 40), CGPoint(x: 4, y: 60), CGPoint(x: 5, y: 85), CGPoint(x: 6, y: 75), CGPoint(x: 7, y: 40), CGPoint(x: 8, y: 70), CGPoint(x: 9, y: 20), CGPoint(x: 10, y: 30), CGPoint(x: 11, y: 45), CGPoint(x: 12, y: 50), CGPoint(x: 13, y: 45), CGPoint(x: 14, y: 50), CGPoint(x: 15, y: 45), CGPoint(x: 16, y: 45), CGPoint(x: 17, y: 30), CGPoint(x: 18, y: 20), CGPoint(x: 19, y: 60), CGPoint(x: 20, y: 80), CGPoint(x: 21, y: 100), CGPoint(x: 22, y: 90), CGPoint(x: 23, y: 80), CGPoint(x: 24, y: 70), CGPoint(x: 25, y: 70), CGPoint(x: 26, y: 75), CGPoint(x: 27, y: 75), CGPoint(x: 28, y: 70), CGPoint(x: 29, y: 70)], toDoCount: 198, announcementCount: 7))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, points: [], toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, points: [], toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
