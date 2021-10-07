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
        let entry = MyMindEntry(date: Date(), isLogin: true, maximumAmount: 100, totalAmount: 1280, chartDatas: [UDILineChartData(points: [CGPoint(x: 0, y: 20), CGPoint(x: 1, y: 25), CGPoint(x: 2, y: 30), CGPoint(x: 3, y: 40), CGPoint(x: 4, y: 60), CGPoint(x: 5, y: 85), CGPoint(x: 6, y: 75), CGPoint(x: 7, y: 40), CGPoint(x: 8, y: 70), CGPoint(x: 9, y: 20), CGPoint(x: 10, y: 30), CGPoint(x: 11, y: 45), CGPoint(x: 12, y: 50), CGPoint(x: 13, y: 45), CGPoint(x: 14, y: 50), CGPoint(x: 15, y: 45), CGPoint(x: 16, y: 45), CGPoint(x: 17, y: 30), CGPoint(x: 18, y: 20), CGPoint(x: 19, y: 60), CGPoint(x: 20, y: 80), CGPoint(x: 21, y: 100), CGPoint(x: 22, y: 90), CGPoint(x: 23, y: 80), CGPoint(x: 24, y: 70), CGPoint(x: 25, y: 70), CGPoint(x: 26, y: 75), CGPoint(x: 27, y: 75), CGPoint(x: 28, y: 70), CGPoint(x: 29, y: 70)], fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3)], toDoCount: 198, announcementCount: 7)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MyMindEntry>) -> ()) {
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        NetworkManager.shared.authorization { authorization, success in
            if success {
                NetworkManager.shared.saleReportList { reportList in
                    NetworkManager.shared.toDoCount(with: authorization?.navigations.description ?? "") { toDoCount in
                        NetworkManager.shared.announcementCount { announcementCount in
                            let entry = MyMindEntry(date: Date(), isLogin: true, maximumAmount: reportList?.maximumAmount ?? 1, totalAmount: reportList?.totalSaleAmount ?? 0, chartDatas: [UDILineChartData(points: reportList?.points(for: .TOTAL_SALE_AMOUNT)[.sale] ?? [], fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3) ], toDoCount: toDoCount, announcementCount: announcementCount)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            } else {
                let entry = MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            }
        }
    }
    func placeholder(in context: Context) -> MyMindEntry {
        MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil)
    }
}
/// intent widget configuration provider
struct ChartProvider: IntentTimelineProvider {
    typealias Entry = MyMindEntry
    typealias Intent = SelectChartIntent

    func getSnapshot(for configuration: SelectChartIntent, in context: Context, completion: @escaping (MyMindEntry) -> Void) {
        let entry = MyMindEntry(date: Date(), isLogin: true, maximumAmount: 100, totalAmount: 1280, chartDatas: [UDILineChartData(points: [CGPoint(x: 0, y: 20), CGPoint(x: 1, y: 25), CGPoint(x: 2, y: 30), CGPoint(x: 3, y: 40), CGPoint(x: 4, y: 60), CGPoint(x: 5, y: 85), CGPoint(x: 6, y: 75), CGPoint(x: 7, y: 40), CGPoint(x: 8, y: 70), CGPoint(x: 9, y: 20), CGPoint(x: 10, y: 30), CGPoint(x: 11, y: 45), CGPoint(x: 12, y: 50), CGPoint(x: 13, y: 45), CGPoint(x: 14, y: 50), CGPoint(x: 15, y: 45), CGPoint(x: 16, y: 45), CGPoint(x: 17, y: 30), CGPoint(x: 18, y: 20), CGPoint(x: 19, y: 60), CGPoint(x: 20, y: 80), CGPoint(x: 21, y: 100), CGPoint(x: 22, y: 90), CGPoint(x: 23, y: 80), CGPoint(x: 24, y: 70), CGPoint(x: 25, y: 70), CGPoint(x: 26, y: 75), CGPoint(x: 27, y: 75), CGPoint(x: 28, y: 70), CGPoint(x: 29, y: 70)], fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3)], toDoCount: 198, announcementCount: 7)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectChartIntent, in context: Context, completion: @escaping (Timeline<MyMindEntry>) -> Void) {
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        NetworkManager.shared.authorization { authorization, success in
            if success {
                NetworkManager.shared.saleReportList { reportList in
                    NetworkManager.shared.toDoCount(with: authorization?.navigations.description ?? "") { toDoCount in
                        NetworkManager.shared.announcementCount { announcementCount in
                            var points: [CGPoint] = []
                            var maximum: CGFloat = 1
                            var total: CGFloat = 0
                            switch configuration.chart {
                            case .saleAmount: points = reportList?.points(for: .TOTAL_SALE_AMOUNT)[.sale] ?? []
                                maximum = max(CGFloat(reportList?.maximumSaleAmount ?? 1), 1)
                                total = reportList?.totalSaleAmount ?? 0
                            case .canceledAmount: points = reportList?.points(for: .TOTAL_SALE_AMOUNT)[.cancel] ?? []
                                maximum = max (CGFloat(reportList?.maximumCanceledAmount ?? 1), 1)
                                total = reportList?.totalCanceledAmount ?? 0
                            case .returnedAmount: points = reportList?.points(for: .TOTAL_SALE_AMOUNT)[.returned] ?? []
                                maximum = max(CGFloat(reportList?.maximumReturnAmount ?? 1), 1)
                                total = reportList?.totalReturnAmount ?? 0
                            case .saleQuantity: points = reportList?.points(for: .TOTAL_SALE_QUANTITY)[.sale] ?? []
                                maximum = max(CGFloat(reportList?.maximumSaleQuantity ?? 1), 1)
                                total = reportList?.totalSaleQuantity ?? 0
                            case .canceledQuanity: points = reportList?.points(for: .TOTAL_SALE_QUANTITY)[.cancel] ?? []
                                maximum = max(CGFloat(reportList?.maximumCanceledQuantity ?? 1), 1)
                                total = reportList?.totalCanceledQuantity ?? 0
                            case .returnedQuantity: points = reportList?.points(for: .TOTAL_SALE_QUANTITY)[.returned] ?? []
                                maximum = max(CGFloat(reportList?.maximumReturnQuantity ?? 1), 1)
                                total = reportList?.totalReturnQuantity ?? 0
                            default: points = reportList?.points(for: .TOTAL_SALE_AMOUNT)[.sale] ?? []
                                maximum = max(CGFloat(reportList?.maximumSaleAmount ?? 1), 1)
                                total = reportList?.totalSaleAmount ?? 0
                            }
                            let entry = MyMindEntry(date: Date(), isLogin: true, maximumAmount: maximum, totalAmount: total, chartDatas: [UDILineChartData(points:  points, fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3) ], toDoCount: toDoCount, announcementCount: announcementCount)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            } else {
                let entry = MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            }
        }
    }
    
    func placeholder(in context: Context) -> MyMindEntry {
        MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil)
    }
}
/// MyMindEntry
struct MyMindEntry: TimelineEntry {
    let date: Date
    let isLogin: Bool
    let maximumAmount: CGFloat
    let totalAmount: CGFloat
    let chartDatas: [UDILineChartData]
    let toDoCount: Int?
    let announcementCount: Int?
}
/// Entry View
struct MyMind_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
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
                    if let points = entry.chartDatas.first?.points, points.count > 1 {
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
                        UDILineChartView(datas: entry.chartDatas, provisionColor: Color(red: 59.0/255.0, green: 82.0/255.0, blue: 105.0/255.0), provisionWidth: 1, maximum: entry.maximumAmount)
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
        IntentConfiguration(kind: kind, intent: SelectChartIntent.self, provider: ChartProvider()) { entry in
            MyMind_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("MyMind")
        .description("Show MyMind Important Infos.")
        .supportedFamilies([.systemLarge])
    }
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
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: 20, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, maximumAmount: 100, totalAmount: 1280, chartDatas: [UDILineChartData(points: [CGPoint(x: 0, y: 20), CGPoint(x: 1, y: 25), CGPoint(x: 2, y: 30), CGPoint(x: 3, y: 40), CGPoint(x: 4, y: 60), CGPoint(x: 5, y: 85), CGPoint(x: 6, y: 75), CGPoint(x: 7, y: 40), CGPoint(x: 8, y: 70), CGPoint(x: 9, y: 20), CGPoint(x: 10, y: 30), CGPoint(x: 11, y: 45), CGPoint(x: 12, y: 50), CGPoint(x: 13, y: 45), CGPoint(x: 14, y: 50), CGPoint(x: 15, y: 45), CGPoint(x: 16, y: 45), CGPoint(x: 17, y: 30), CGPoint(x: 18, y: 20), CGPoint(x: 19, y: 60), CGPoint(x: 20, y: 80), CGPoint(x: 21, y: 100), CGPoint(x: 22, y: 90), CGPoint(x: 23, y: 80), CGPoint(x: 24, y: 70), CGPoint(x: 25, y: 70), CGPoint(x: 26, y: 75), CGPoint(x: 27, y: 75), CGPoint(x: 28, y: 70), CGPoint(x: 29, y: 70)], fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3)], toDoCount: 198, announcementCount: 7))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: false, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: MyMindEntry(date: Date(), isLogin: true, maximumAmount: 1, totalAmount: 0, chartDatas: [], toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            UDIPieChartView(data: UDIPieChartData(slices: [UDIPieSliceData(ratio: 0.3, title: "Yahoo", color: .red), UDIPieSliceData(ratio: 0.4, title: "Shoppe", color: .green), UDIPieSliceData(ratio: 0.3, title: "PCHome", color: .blue)], borderColor: .white, holeRatio: nil, title: nil), showDescription: false).previewContext(WidgetPreviewContext(family: .systemSmall))
            UDIPieChartView(data: UDIPieChartData(slices: [UDIPieSliceData(ratio: 0.3, title: "Yahoo", color: .red), UDIPieSliceData(ratio: 0.4, title: "Shoppe", color: .green), UDIPieSliceData(ratio: 0.3, title: "PCHome", color: .blue)], borderColor: .white, holeRatio: 0.4, title:"供應商"), showDescription: false).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
