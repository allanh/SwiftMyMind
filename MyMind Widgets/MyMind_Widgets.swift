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
class LineChartLeftAxisValueFormatter: IAxisValueFormatter {
    static let shared: LineChartLeftAxisValueFormatter = .init()

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
class LineChartBottomAxisValueFormatter: IAxisValueFormatter {
    static let shared: LineChartBottomAxisValueFormatter = .init()
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: date)
    }
}
/// extension
extension UIView {
    var image: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            if let context = UIGraphicsGetCurrentContext() {
                layer.render(in: context)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                return image
            }
            return nil
        }
    }
}
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for report in reports {
            if let date = report.date {
                let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
                switch order {
                case .TOTAL_SALE_QUANTITY:
                    saleEntries[components.day!].y += Double(report.saleQuantity)
                    canceledEntries[components.day!].y += Double(report.canceledQuantity)
                    returnedEntries[components.day!].y += Double(report.returnQuantity)
                case .TOTAL_SALE_AMOUNT:
                    saleEntries[components.day!].y += Double(report.saleAmount)
                    canceledEntries[components.day!].y += Double(report.canceledAmount)
                    returnedEntries[components.day!].y += Double(report.returnAmount)
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
    func chartPath(width: CGFloat, height: CGFloat, maxY: CGFloat) -> Path {
        var path = Path()
        let heightRatio = height/maximumAmount
        let toDate: Date = Date().yesterday
        let fromDate: Date = toDate.thirtyDaysBefore
        let offset = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
        var salePoints: [CGPoint] = (0..<offset).map { (i) -> CGPoint in
            return CGPoint(x: CGFloat(CGFloat(i)*width)+10, y: 0)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for report in reports {
            if let date = report.date {
                let components = Calendar.current.dateComponents([.day], from: fromDate, to: formatter.date(from: date)!)
                salePoints[components.day!].y += CGFloat(report.saleAmount)*heightRatio
            }
        }
        salePoints = salePoints.map { origin in
            return CGPoint(x: origin.x, y: maxY - origin.y)
        }
//        for index in 0..<salePoints.count {
//            salePoints[index].y = maxY - salePoints[index].y
//        }
        var previousPoint: CGPoint?
        var isFirst = true
        for index in 0..<salePoints.count {
            let point = salePoints[index]
            if let previousPoint = previousPoint {
                let midPoint = CGPoint(
                    x: (point.x + previousPoint.x) / 2,
                    y: (point.y + previousPoint.y) / 2
                )
                if isFirst {
                    path.addLine(to: midPoint)
                    isFirst = false
                } else if index == salePoints.count - 1{
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
//        path.addLines(salePoints)
        return path
    }
}
extension LineChartView {
    convenience init(frame: CGRect, entry: Provider.Entry) {
        self.init(frame: frame)
        self.backgroundColor = .white
        self.drawGridBackgroundEnabled = false
        self.chartDescription?.enabled = false
        
        let leftAxis = self.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMaximum = 10000
        leftAxis.axisMinimum = 0
        leftAxis.valueFormatter = LineChartLeftAxisValueFormatter.shared
        
        let xAxis = self.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .pingFangTCRegular(ofSize: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = LineChartBottomAxisValueFormatter.shared

        self.rightAxis.enabled = false
        self.legend.form = .line
        if let reportList = entry.reportList, reportList.reports.count > 0 {
            let maximum = reportList.maximumAmount
            leftAxis.axisMaximum = maximum + maximum/10
            self.data = reportList.lineChartData(order: SKURankingReport.SKURankingReportSortOrder.TOTAL_SALE_AMOUNT)
        } else {
            leftAxis.axisMaximum = 10000
            self.data = SaleReportList.emptyLineChartData(order: SKURankingReport.SKURankingReportSortOrder.TOTAL_SALE_AMOUNT)
        }
    }
}
/// Network
class NetworkManager {
    static let shared: NetworkManager = .init()
    let version: String = "v1"
    static let baseURL: String = {
        if let url = Bundle.main.infoDictionary?["ServerURL"] as? String {
            return url
        }
        return ""
    }()
    var authorizationURL: URL {
        get {
            var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
            components?.path = "/api/admin/\(version)/authorization"
            guard let url = components?.url else {
                preconditionFailure("Invalid URL components: \(String(describing: components))")
            }
            return url
        }
    }
    func saleReport(partnerID: String, start: Date, end: Date, type: SaleReport.SaleReportType) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "channel_receipt_date_from", value: formatter.string(from: start)+" 00:00:00"),
            URLQueryItem(name: "channel_receipt_date_to", value: formatter.string(from: end)+" 23:59:59")
        ]
        var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
        switch type {
        case .byType:
            components?.path = "/api/admin/\(version)/dashboard/order_sale_by_type"
            components?.queryItems = items
            guard let url = components?.url else {
                preconditionFailure("Invalid URL components: \(String(describing: components))")
            }
            return url
        case .byDate:
            components?.path = "/api/admin/\(version)/dashboard/order_sale_by_date"
            components?.queryItems = items
            guard let url = components?.url else {
                preconditionFailure("Invalid URL components: \(String(describing: components))")
            }
            return url
        }
    }
    func todo(partnerID: String, navigationNo: String) -> URL {
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "navigation_no", value: navigationNo),
        ]
        var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
        components?.path = "/api/admin/\(version)/dashboard/todo"
        components?.queryItems = items
        guard let url = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
    func notifications(number: Int) -> URL {
        var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
        components?.path = "/api/admin/\(version)/notification"
        components?.queryItems = [URLQueryItem(name: "take", value: String(number))]
        guard let url = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
    func readUserSession() -> UserSession? {
        do {
            let userSession = try KeychainHelper.default.readItem(key: .userSession, valueType: UserSession.self)
            return userSession
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    func request(url: URL,
                 httpMethod: String = "GET",
                 httpHeader: [String: String]? = nil,
                 httpBody: Data? = nil,
                 timeoutInterval: TimeInterval = 15) -> URLRequest {

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = httpMethod

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let body = httpBody {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        if let header = httpHeader {
            for (key, value) in header {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

    func authorization(completion: @escaping (Authorization?, Bool) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil, false)
            return
        }
        let request = request(url: authorizationURL, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil, false)
                return
            }

            guard let jsonData = data else {
                completion(nil, false)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<Authorization>.self, from: jsonData)
                guard let authorization = response.data else {
                    completion(nil, false)
                    return
                }
                completion(authorization, true)
            } catch {
                completion(nil, false)
            }
        }
        task.resume()
    }
    func saleReportList(completion: @escaping (SaleReportList?) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil)
            return
        }
        let end = Date()
        let request = request(
            url: saleReport(partnerID: "\(userSession.partnerInfo.id)", start: end.thirtyDaysBefore, end: end, type: .byDate),
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }

            guard let jsonData = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<SaleReportList>.self, from: jsonData)
                guard let item = response.data else {
                    completion(nil)
                    return
                }
                completion(item)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    func toDoCount(with navigationNo: String, completion: @escaping  (Int?) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil)
            return
        }

        let url = todo(partnerID: "\(userSession.partnerInfo.id)", navigationNo: navigationNo)


        let request = request(
            url: url,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }

            guard let jsonData = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<ToDoList>.self, from: jsonData)
                guard let item = response.data else {
                    completion(nil)
                    return
                }
                completion(item.items.count)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    func announcementCount(completion: @escaping (Int?) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil)
            return
        }

        let url = notifications(number: 3)

        let request = request(
            url: url,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }

            guard let jsonData = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<MyMindNotificationList>.self, from: jsonData)
                guard let item = response.data else {
                    completion(nil)
                    return
                }
                completion(item.items.count)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
/// widget
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), isLogin: true, reportList: nil, toDoCount: nil, announcementCount: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), isLogin: true, reportList: nil, toDoCount: nil, announcementCount: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        print("Get Time Line")
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        NetworkManager.shared.authorization { authorization, success in
            if success {
                NetworkManager.shared.saleReportList { reportList in
                    NetworkManager.shared.toDoCount(with: authorization?.navigations.description ?? "") { toDoCount in
                        NetworkManager.shared.announcementCount { announcementCount in
                            let entry = SimpleEntry(date: Date(), isLogin: true, reportList: reportList, toDoCount: toDoCount, announcementCount: announcementCount)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            } else {
                let entry = SimpleEntry(date: Date(), isLogin: false, reportList: nil, toDoCount: nil, announcementCount: nil)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            }
        }
        //        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, isLogin: true, reportList: nil, toDoCount: 0, announcementCount: 0)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }
}
/// Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let isLogin: Bool
    let reportList: SaleReportList?
    let toDoCount: Int?
    let announcementCount: Int?
}
///
/// Chart View
struct ChartView : View {
    let reportList: SaleReportList?
    @State var labels: [String] = ["", "", ""]
//    let labels: [String] //= ["11/01","12/01","1/1"]
    var body : some View {
        ZStack {
            GeometryReader { geo in
                let frame = geo.frame(in: .named("chart parent"))
                if let reportList = reportList {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0), Color(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0)], startPoint: .top, endPoint: .bottom))
                        .clipShape(reportList.chartPath(width: (frame.size.width-20)/29, height: frame.size.height, maxY: frame.maxY))
                        .blendMode(.overlay)
                    Path { path in
                        path = reportList.chartPath(width: (frame.size.width-20)/29, height: frame.size.height, maxY: frame.maxY)
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }
                
                Path { path in
                    path.move(to: CGPoint(x: frame.minX, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
                }
                .stroke(Color.gray, lineWidth: 1)
                Path { path in
                    path.move(to: CGPoint(x: frame.minX+(frame.size.width-20)/3, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX+(frame.size.width-20)/3, y: frame.maxY))
                }
                .stroke(Color.gray, lineWidth: 1)
                Path { path in
                    path.move(to: CGPoint(x: frame.minX+(frame.size.width-20)/1.5, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX+(frame.size.width-20)/1.5, y: frame.maxY))
                }
                .stroke(Color.gray, lineWidth: 1)
                Path { path in
                    path.move(to: CGPoint(x: frame.maxX-20, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.maxX-20, y: frame.maxY))
                }
                .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Text(labels[0])
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "M/d"
                            let date = Calendar.current.date(byAdding: .day, value: 5, to: Date().thirtyDaysBefore)!
                            labels[0] = formatter.string(from: date)
                        }
                    Text(labels[1])
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "M/d"
                            let date = Calendar.current.date(byAdding: .day, value: 15, to: Date().thirtyDaysBefore)!
                            labels[1] = formatter.string(from: date)
                        }
                    Text(labels[2])
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "M/d"
                            let date = Calendar.current.date(byAdding: .day, value: 25, to: Date().thirtyDaysBefore)!
                            labels[2] = formatter.string(from: date)
                        }
                }
                .frame(width: frame.size.width-20)
                .offset(x: 10, y: 0)
            }
        }
        .padding(.trailing, 10)
        .padding(.leading, 10)
        .coordinateSpace(name: "chart parent")
    }
}
///  Indicator View
struct IndicatorView : View {
    let count: Int?
    let title: String
    let colors: [Color]
    var body : some View {
        HStack {
            Rectangle()
                .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                .blendMode(.overlay)
                .frame(width: 6)
                .cornerRadius(3)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("PingFangTC-Regular", size: 14))
                    .foregroundColor(.white)
                if let count = count {
                    Text("\(count)")
                        .font(.custom("PingFangTC-Semibold", size: 24))
                        .foregroundColor(.white)

                } else {
                    Text("-")
                        .font(.custom("PingFangTC-Semibold", size: 24))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
/// Entry View
struct MyMind_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    lazy var view = LineChartView(frame: CGRect(x: 0, y: 0, width: 320, height: 180), entry: entry)
    func viewValue() -> some UIView {
        var mutatableSelf = self
        return mutatableSelf.view
    }

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            VStack {
                HStack {
                    Text("MyMind")
                        .frame(height: 24, alignment: .topLeading)
                        .font(.custom("PingFangTC-Semibold", size: 14))
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                        .padding(.top, 20)
                    Spacer()
                }
                if entry.isLogin {
                    Spacer(minLength: 20)
                    HStack {
                        IndicatorView(count: entry.toDoCount, title: "代辦事項", colors: [Color(red: 139.0/255.0, green: 134.0/255.0, blue: 196.0/255.0), Color(red: 112.0/255.0, green: 107.0/255.0, blue: 178.0/255.0)])
                            .frame(maxWidth: .infinity)
                        Spacer()
                        IndicatorView(count: entry.announcementCount, title: "公告通知", colors: [Color(red: 195.0/255.0, green: 117.0/255.0, blue: 121.0/255.0), Color(red: 160.0/255.0, green: 75.0/255.0, blue: 99.0/255.0)])
                            .frame(maxWidth: .infinity)
                        Spacer()
                        Link(destination: URL(string: "mymindwidget://otp")!) {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                                Text("OTP")
                                    .font(.custom("PingFangTC-Semibold", size: 24))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .cornerRadius(16)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.trailing, 16)
                    .padding(.leading, 16)
                    .padding(.bottom, 20)
                } else {
                    Spacer()
                    HStack {
                        Link(destination: URL(string: "mymindwidget://login")!) {
                            HStack {
                                Spacer()
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .foregroundColor(Color.orange)
                                VStack {
                                    Text("尚未連線請先行登入")
                                        .font(.custom("PingFangTC-Semibold", size: 15))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(maxHeight: .infinity)
                                    Text("登入")
                                        .font(.custom("PingFangTC-Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 10)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.yellow, lineWidth: 2))
                                }
                                Spacer()
                            }
                            .frame(width: 185)
                        }
                        Spacer()
                        Link(destination: URL(string: "mymindwidget://otp")!) {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                                Text("OTP")
                                    .font(.custom("PingFangTC-Semibold", size: 24))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .cornerRadius(16)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.trailing, 16)
                    .padding(.leading, 16)
                    .padding(.bottom, 20)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [Color(UIColor(hex: "133150")), .black], startPoint: .top, endPoint: .bottom))
        case .systemLarge:
            VStack {
                Spacer()
                HStack {
                    Text("近30日銷售數據")
                        .frame(height: 24, alignment: .topLeading)
                        .font(.custom("PingFangTC-Regular", size: 14))
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                        .padding(.top, 20)
                    Spacer()
                    Text("MyMind")
                        .frame(height: 24, alignment: .topTrailing)
                        .font(.custom("PingFangTC-Semibold", size: 14))
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                        .padding(.top, 20)
                }
                Spacer()
                if entry.isLogin {
                    ChartView(reportList: entry.reportList)
                } else {
                    Link(destination: URL(string: "mymindwidget://login")!) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .frame(width: 48, height: 48, alignment: .center)
                                .foregroundColor(Color.orange)
                            VStack {
                                Spacer(minLength: 60)
                                Text("尚未連線請先行登入")
                                    .font(.custom("PingFangTC-Semibold", size: 18))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("登入")
                                    .font(.custom("PingFangTC-Regular", size: 16))
                                    .foregroundColor(.white)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.yellow, lineWidth: 2))
                                Spacer(minLength: 60)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                Spacer(minLength: 20)
                HStack {
                    IndicatorView(count: entry.toDoCount, title: "代辦事項", colors: [Color(red: 139.0/255.0, green: 134.0/255.0, blue: 196.0/255.0), Color(red: 112.0/255.0, green: 107.0/255.0, blue: 178.0/255.0)])
                        .frame(maxWidth: .infinity)
                    Spacer()
                    IndicatorView(count: entry.announcementCount, title: "公告通知", colors: [Color(red: 195.0/255.0, green: 117.0/255.0, blue: 121.0/255.0), Color(red: 160.0/255.0, green: 75.0/255.0, blue: 99.0/255.0)])
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Link(destination: URL(string: "mymindwidget://otp")!) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.white)
                            Text("OTP")
                                .font(.custom("PingFangTC-Semibold", size: 24))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .cornerRadius(16)
                    }
                }
                .frame(height: 48)
                .padding(.trailing, 16)
                .padding(.leading, 16)
                .padding(.bottom, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [Color(UIColor(hex: "133150")), .black], startPoint: .top, endPoint: .bottom))
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
            MyMind_WidgetsEntryView(entry: SimpleEntry(date: Date(), isLogin: true, reportList: nil, toDoCount: 20, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MyMind_WidgetsEntryView(entry: SimpleEntry(date: Date(), isLogin: true, reportList: nil, toDoCount: 20, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            MyMind_WidgetsEntryView(entry: SimpleEntry(date: Date(), isLogin: true, reportList: nil, toDoCount: nil, announcementCount: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
