//
//  UDILineChart.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//
import SwiftUI
struct UDILineChartData {
    let points: [CGPoint]
    let fill: LinearGradient
    let stroke: Color
    let strokeWidth: CGFloat
    var maximum: CGFloat {
        get {
            let max = points.map{ $0.y }.sorted{ $0 > $1}.first ?? 0
            if max == 0 {
                return 1000
            }
            return max+10
        }
    }
    var minimum: CGFloat {
        get {
            let min = points.map{ $0.y }.sorted{ $0 < $1}.first ?? 0
            return max(min-10, 0)
        }
    }
    static var empty: UDILineChartData = UDILineChartData(points: [], fill: LinearGradient(colors: [], startPoint: .top, endPoint: .bottom), stroke: .clear, strokeWidth: 0)
    static var mock: UDILineChartData = UDILineChartData(
        points: [
            CGPoint(x: 0, y: 10000),
            CGPoint(x: 1, y: 10003),
            CGPoint(x: 2, y: 10005),
            CGPoint(x: 3, y: 10009),
            CGPoint(x: 4, y: 10012),
            CGPoint(x: 5, y: 10017),
            CGPoint(x: 6, y: 10019),
            CGPoint(x: 7, y: 10020),
            CGPoint(x: 8, y: 10021),
            CGPoint(x: 9, y: 10020),
            CGPoint(x: 10, y: 10018),
            CGPoint(x: 11, y: 10017),
            CGPoint(x: 12, y: 10014),
            CGPoint(x: 13, y: 10013),
            CGPoint(x: 14, y: 10010),
            CGPoint(x: 15, y: 10009),
            CGPoint(x: 16, y: 10012),
            CGPoint(x: 17, y: 10015),
            CGPoint(x: 18, y: 10018),
            CGPoint(x: 19, y: 10023),
            CGPoint(x: 20, y: 10030),
            CGPoint(x: 21, y: 10035),
            CGPoint(x: 22, y: 10040),
            CGPoint(x: 23, y: 10050),
            CGPoint(x: 24, y: 10052),
            CGPoint(x: 25, y: 10055),
            CGPoint(x: 26, y: 10050),
            CGPoint(x: 27, y: 10040),
            CGPoint(x: 28, y: 10035),
            CGPoint(x: 29, y: 10035)
        ], fill: LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom), stroke: Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), strokeWidth: 3)
    func path(with frame: CGRect) -> Path {
        var path = Path()
        let heightRatio: CGFloat = (frame.size.height-17)/(maximum-minimum)
        let itemWidth = frame.size.width/CGFloat((points.count > 1) ? points.count - 1 : 1)
        let drawPoints = points.map { origin in
            return CGPoint(x: (origin.x*itemWidth), y: frame.maxY - ((origin.y - minimum)*heightRatio))
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
        let heightRatio: CGFloat = (frame.size.height-17)/(maximum-minimum)
        let itemWidth = frame.size.width/CGFloat((points.count > 1) ? points.count - 1 : 1)
        let drawPoints = points.map { origin in
            return CGPoint(x: (origin.x*itemWidth), y: frame.maxY - ((origin.y - minimum)*heightRatio))
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
/// Chart View
struct UDILineChartView : View {
    let data: UDILineChartData
    let provisionColor: Color
    let provisionWidth: CGFloat
    let maximum: CGFloat
    let minimum: CGFloat
    @State var labels: [String] = ["", "", ""]
    var body : some View {
        ZStack {
            GeometryReader { geo in
                let frame = geo.frame(in: .named("chart parent"))
                if let points = data.points, points.count > 1, let gradient = data.fill {
                    Rectangle()
                        .fill(gradient)
                        .clipShape(data.closePath(with: frame))
                        .blendMode(.sourceAtop)
                }
                Path { path in
                    path.move(to: CGPoint(x: frame.minX, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
                }
                .stroke(provisionColor, lineWidth: provisionWidth)
                Path { path in
                    path.move(to: CGPoint(x: frame.minX+(frame.size.width)/3, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX+(frame.size.width)/3, y: frame.maxY))
                }
                .stroke(provisionColor, lineWidth: provisionWidth)
                Path { path in
                    path.move(to: CGPoint(x: frame.minX+(frame.size.width)/1.5, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX+(frame.size.width)/1.5, y: frame.maxY))
                }
                .stroke(provisionColor, lineWidth: provisionWidth)
                Path { path in
                    path.move(to: CGPoint(x: frame.maxX, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
                }
                .stroke(provisionColor, lineWidth: provisionWidth)
                if let points = data.points, points.count > 1, let color = data.stroke, let width = data.strokeWidth {
                    Path { path in
                        path = data.path(with: frame)
                    }
                    .stroke(color, lineWidth: width)
                }
                HStack {
                    Text(labels[0])
                        .foregroundColor(Color(white: 180.0/255, opacity: 1.0))
                        .font(.custom("PingFangTC-Regular", size: 12))
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "M/d"
                            let date = Calendar.current.date(byAdding: .day, value: 5, to: Date().thirtyDaysBefore)!
                            labels[0] = formatter.string(from: date)
                        }
                    Text(labels[1])
                        .foregroundColor(Color(white: 180.0/255, opacity: 1.0))
                        .font(.custom("PingFangTC-Regular", size: 12))
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "M/d"
                            let date = Calendar.current.date(byAdding: .day, value: 15, to: Date().thirtyDaysBefore)!
                            labels[1] = formatter.string(from: date)
                        }
                    Text(labels[2])
                        .foregroundColor(Color(white: 180.0/255, opacity: 1.0))
                        .font(.custom("PingFangTC-Regular", size: 12))
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "M/d"
                            let date = Calendar.current.date(byAdding: .day, value: 25, to: Date().thirtyDaysBefore)!
                            labels[2] = formatter.string(from: date)
                        }
                }
                .frame(width: frame.size.width)
            }
        }
        .coordinateSpace(name: "chart parent")
    }
}
