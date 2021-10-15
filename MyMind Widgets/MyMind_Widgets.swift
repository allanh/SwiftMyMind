//
//  MyMind_Widgets.swift
//  MyMind Widgets
//
//  Created by Nelson Chan on 2021/9/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
/// Static Widget configuration provider
struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (MyMindEntry) -> ()) {
        let entry = MyMindEntry.mock
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MyMindEntry>) -> ()) {
        NetworkManager.shared.authorization { authorization, success in
            guard success else {
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                let entry = MyMindEntry.empty
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
                return
            }
            NetworkManager.shared.saleReportList { reportList, success in
                guard success else {
                    let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                    let entry = MyMindEntry.empty
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                    completion(timeline)
                    return
                }
                NetworkManager.shared.toDoCount(with: authorization?.navigations.description ?? "") { toDoCount, success in
                    guard success else {
                        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                        let entry = MyMindEntry.empty
                        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                        completion(timeline)
                        return
                    }
                    NetworkManager.shared.announcementCount { announcementCount, success in
                        guard success else {
                            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                            let entry = MyMindEntry.empty
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                            return
                        }
                        NetworkManager.shared.todayReport { reportOfToday, success in
                            guard success else {
                                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                                let entry = MyMindEntry.empty
                                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                                completion(timeline)
                                return
                            }
                            var points: [CGPoint] = []
                            var maximum: CGFloat = 1
                            var total: CGFloat = 0
                            var today: CGFloat = 0
                            var source: SourceType?
                            if let reportList = reportList {
                                points = reportList.points(for: .TOTAL_SALE_AMOUNT)[.sale] ?? []
                                maximum = CGFloat(reportList.maximumSaleAmount)
                                if maximum == 0 {
                                    maximum = 10000
                                } else {
                                    maximum += maximum/10
                                }
                                total = max(reportList.totalSaleAmount, 0)
                                if let shipped = reportOfToday?.todayShippedSaleReport {
                                    today += CGFloat(shipped.saleAmount)
                                }
                                if let transformed = reportOfToday?.todayTransformedSaleReport {
                                    today += CGFloat(transformed.saleAmount)
                                }
                                source = .saleAmount
                            }
                            let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                            let entry = MyMindEntry(date: Date(), isLogin: true, source: source, maximumAmount: maximum, totalAmount: total, todayAmount: today, chartData: UDILineChartData(points:  points, fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3), toDoCount: toDoCount, announcementCount: announcementCount)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            }
        }
    }
    func placeholder(in context: Context) -> MyMindEntry {
        MyMindEntry(date: Date(), isLogin: true, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: .empty, toDoCount: nil, announcementCount: nil)
    }
}
/// intent widget configuration provider
struct ChartProvider: IntentTimelineProvider {
    typealias Entry = MyMindEntry
    typealias Intent = SelectChartIntent

    func getSnapshot(for configuration: SelectChartIntent, in context: Context, completion: @escaping (MyMindEntry) -> Void) {
        let entry = MyMindEntry.mock
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectChartIntent, in context: Context, completion: @escaping (Timeline<MyMindEntry>) -> Void) {
        NetworkManager.shared.authorization { authorization, success in
            guard success else {
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                let entry = MyMindEntry.empty
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
                return
            }
            NetworkManager.shared.saleReportList { reportList, success in
                guard success else {
                    let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                    let entry = MyMindEntry.empty
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                    completion(timeline)
                    return
                }
                NetworkManager.shared.toDoCount(with: authorization?.navigations.description ?? "") { toDoCount, success in
                    guard success else {
                        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                        let entry = MyMindEntry.empty
                        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                        completion(timeline)
                        return
                    }
                    NetworkManager.shared.announcementCount { announcementCount, success in
                        guard success else {
                            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                            let entry = MyMindEntry.empty
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                            return
                        }
                        NetworkManager.shared.todayReport { reportOfToday, success in
                            guard success else {
                                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                                let entry = MyMindEntry.empty
                                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                                completion(timeline)
                                return
                            }
                            var points: [CGPoint] = []
                            var maximum: CGFloat = 1
                            var total: CGFloat = 0
                            var today: CGFloat = 0
                            var source: SourceType?
                            if let reportList = reportList {
                                switch configuration.source {
                                case .saleAmount: points = reportList.points(for: .TOTAL_SALE_AMOUNT)[.sale] ?? []
                                    maximum = CGFloat(reportList.maximumSaleAmount)
                                    if maximum == 0 {
                                        maximum = 10000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalSaleAmount, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.saleAmount)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.saleAmount)
                                    }
                                    source = .saleAmount
                                case .canceledAmount: points = reportList.points(for: .TOTAL_SALE_AMOUNT)[.cancel] ?? []
                                    maximum = CGFloat(reportList.maximumCanceledAmount)
                                    if maximum == 0 {
                                        maximum = 10000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalCanceledAmount, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.canceledAmount)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.canceledAmount)
                                    }
                                    source = .cancelAmount
                                case .returnedAmount: points = reportList.points(for: .TOTAL_SALE_AMOUNT)[.returned] ?? []
                                    maximum = CGFloat(reportList.maximumReturnAmount)
                                    if maximum == 0 {
                                        maximum = 10000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalReturnAmount, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.returnAmount)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.returnAmount)
                                    }
                                    source = .returnedAmount
                                case .saleQuantity: points = reportList.points(for: .TOTAL_SALE_QUANTITY)[.sale] ?? []
                                    maximum = CGFloat(reportList.maximumSaleQuantity)
                                    if maximum == 0 {
                                        maximum = 1000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalSaleQuantity, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.saleQuantity)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.saleQuantity)
                                    }
                                    source = .saleQuantity
                                case .canceledQuanity: points = reportList.points(for: .TOTAL_SALE_QUANTITY)[.cancel] ?? []
                                    maximum = CGFloat(reportList.maximumCanceledQuantity)
                                    if maximum == 0 {
                                        maximum = 1000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalCanceledQuantity, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.canceledQuantity)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.canceledQuantity)
                                    }
                                    source = .cancelQuantity
                                case .returnedQuantity: points = reportList.points(for: .TOTAL_SALE_QUANTITY)[.returned] ?? []
                                    maximum = CGFloat(reportList.maximumReturnQuantity)
                                    if maximum == 0 {
                                        maximum = 1000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalReturnQuantity, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.returnQuantity)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.returnQuantity)
                                    }
                                    source = .returnedQuantity
                                default: points = reportList.points(for: .TOTAL_SALE_AMOUNT)[.sale] ?? []
                                    maximum = CGFloat(reportList.maximumSaleAmount)
                                    if maximum == 0 {
                                        maximum = 1000
                                    } else {
                                        maximum += maximum/10
                                    }
                                    total = max(reportList.totalSaleAmount, 0)
                                    if let shipped = reportOfToday?.todayShippedSaleReport {
                                        today += CGFloat(shipped.saleAmount)
                                    }
                                    if let transformed = reportOfToday?.todayTransformedSaleReport {
                                        today += CGFloat(transformed.saleAmount)
                                    }
                                    source = .saleAmount
                                }
                            }
                            let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                            let entry = MyMindEntry(date: Date(), isLogin: true, source: source, maximumAmount: maximum, totalAmount: total, todayAmount: today, chartData: UDILineChartData(points:  points, fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: configuration.strokeWidth as? CGFloat ?? 3), toDoCount: toDoCount, announcementCount: announcementCount)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            }
        }
    }
    
    func placeholder(in context: Context) -> MyMindEntry {
        MyMindEntry(date: Date(), isLogin: true, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: UDILineChartData.empty, toDoCount: nil, announcementCount: nil)
    }
}
enum SourceType: CustomStringConvertible {
    case saleAmount, cancelAmount, returnedAmount, saleQuantity, cancelQuantity, returnedQuantity
    var description: String {
        get {
            switch self {
            case .saleAmount: return "近30日銷售總額"
            case .cancelAmount: return "近30日銷售取消總額"
            case .returnedAmount: return "近30日銷退總額"
            case .saleQuantity: return "近30日銷售總數"
            case .cancelQuantity: return "近30日銷售取消總數"
            case .returnedQuantity: return "近30日銷退總數"
            }
        }
    }
    var todayDescription: String {
        get {
            switch self {
            case .saleAmount: return "今日銷售總額"
            case .cancelAmount: return "今日銷售取消總額"
            case .returnedAmount: return "今日銷退總額"
            case .saleQuantity: return "今日銷售總數"
            case .cancelQuantity: return "今日銷售取消總數"
            case .returnedQuantity: return "今日銷退總數"
            }
        }
    }
}
/// MyMindEntry
struct MyMindEntry: TimelineEntry {
    let date: Date
    let isLogin: Bool
    let source: SourceType?
    let maximumAmount: CGFloat
    let totalAmount: CGFloat
    let todayAmount: CGFloat
    let chartData: UDILineChartData
    let toDoCount: Int?
    let announcementCount: Int?
    static var mock: MyMindEntry = MyMindEntry(date: Date(), isLogin: true, source: .saleAmount, maximumAmount: 110, totalAmount: 102560, todayAmount: 2560, chartData: UDILineChartData.mock, toDoCount: 198, announcementCount: 7)
    static var empty: MyMindEntry = MyMindEntry(date: Date(), isLogin: false, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: .empty, toDoCount: nil, announcementCount: nil)
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusViewModifier(radius: radius, corners: corners))
    }
}
/// Entry View
struct MyMind_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: MyMindEntry
    var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
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
                HStack (alignment: .top, spacing: 0) {
                    GeometryReader { geo in
                        Image("logo")
                            .blendMode(.sourceAtop)
                            .padding(.top, 8)
                        if entry.isLogin {
                            if let points = entry.chartData.points, points.count > 1, let title = entry.source?.description {
                                Spacer()
                                VStack(alignment:.trailing, spacing: 0) {
                                    Text(title)
                                        .font(.custom("PingFangTC-Regular", size: 12))
                                        .foregroundColor(Color(white: 1.0, opacity: 0.65))
                                        .blendMode(.sourceAtop)
                                        .padding(.trailing, 6)
                                    Text(formatter.string(from: NSNumber( value: entry.totalAmount)) ?? "")
                                        .font(.custom("PingFangTC-Semibold", size: 18))
                                        .foregroundColor(.white)
                                        .blendMode(.sourceAtop)
                                        .padding(.trailing, 6)
                                }
                                .frame(width: (geo.size.width-20)/3)
                                .frame(maxHeight: .infinity)
                                .padding(.leading, (geo.size.width-20)/3)
                            }
                            if let title = entry.source?.todayDescription {
                                VStack(alignment: .trailing, spacing: 0) {
                                    Text(title)
                                        .font(.custom("PingFangTC-Regular", size: 12))
                                        .foregroundColor(Color(white: 1.0, opacity: 0.65))
                                        .blendMode(.sourceAtop)
                                    Text(formatter.string(from: NSNumber( value: entry.todayAmount)) ?? "")
                                        .font(.custom("PingFangTC-Semibold", size: 18))
                                        .foregroundColor(.white)
                                        .blendMode(.sourceAtop)
                                }
                                .frame(width: (geo.size.width-20)/3+20)
                                .frame(maxHeight: .infinity)
                                .background(Color(white: 0, opacity: 0.5))
                                .cornerRadius(8, corners:[.topLeft, .bottomLeft])
                                .padding(.leading, (geo.size.width-20)*2/3)
                            }
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.top, 8)
                .frame(height: 56)
                if entry.isLogin {
                    VStack(alignment: .leading) {
                        UDILineChartView(data: entry.chartData, provisionColor: Color(red: 59.0/255.0, green: 82.0/255.0, blue: 105.0/255.0), provisionWidth: 1, maximum: entry.maximumAmount)
                            .blendMode(.sourceAtop)
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                    .frame(maxHeight: .infinity)
                } else {
                    LoginView()
                        .frame(maxHeight: .infinity)
                        .blendMode(.sourceAtop)
                        .padding(.bottom, 51)
                }
                Spacer(minLength: 16)
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
/// widget
struct MyMind_Widget: Widget {
    let kind: String = "MyMind_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyMind_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("MyMind")
        .description("Show MyMind Important Infos.")
        .supportedFamilies([.systemMedium])
    }
}
struct MyMind_ChartWidget: Widget {
    let kind: String = "MyMind_ChartWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyMind_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("MyMind")
        .description("Show MyMind Important Infos.")
        .supportedFamilies([.systemLarge])
    }
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: SelectChartIntent.self, provider: ChartProvider()) { entry in
//            MyMind_WidgetsEntryView(entry: entry)
//        }
//        .configurationDisplayName("MyMind")
//        .description("Show MyMind Important Infos.")
//        .supportedFamilies([.systemLarge])
//    }
}
/// widget bundle
@main
struct MyMind_Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MyMind_Widget()
        MyMind_ChartWidget()
    }
}
/// preview
struct MyMind_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: .empty, toDoCount: 20, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: false, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: .empty, toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: MyMindEntry.mock)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: false, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: .empty, toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, source: nil, maximumAmount: 1, totalAmount: 0, todayAmount: 0, chartData: .empty, toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            UDIPieChartView(data: UDIPieChartData(slices: [UDIPieSliceData(ratio: 0.3, title: "Yahoo", color: .red), UDIPieSliceData(ratio: 0.4, title: "Shoppe", color: .green), UDIPieSliceData(ratio: 0.3, title: "PCHome", color: .blue)], borderColor: .white, holeRatio: nil, title: nil), showDescription: false).previewContext(WidgetPreviewContext(family: .systemSmall))
            UDIPieChartView(data: UDIPieChartData(slices: [UDIPieSliceData(ratio: 0.3, title: "Yahoo", color: .red), UDIPieSliceData(ratio: 0.4, title: "Shoppe", color: .green), UDIPieSliceData(ratio: 0.3, title: "PCHome", color: .blue)], borderColor: .white, holeRatio: 0.4, title:"供應商"), showDescription: false).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
