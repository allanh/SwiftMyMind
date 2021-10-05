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
    func path(with frame: CGRect, maximum: CGFloat) -> Path {
        var path = Path()
        let heightRatio: CGFloat = frame.size.height/maximum
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
    func closePath(with frame: CGRect, maximum: CGFloat) -> Path {
        var path = Path()
        let heightRatio: CGFloat = frame.size.height/maximum
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
/// Chart View
struct UDILineChartView : View {
    let datas: [UDILineChartData]
    let provisionColor: Color
    let provisionWidth: CGFloat
    let maximum: CGFloat
    @State var labels: [String] = ["", "", ""]
    var body : some View {
        ZStack {
            GeometryReader { geo in
                let frame = geo.frame(in: .named("chart parent"))
                ForEach(0..<datas.count) { index in
                    if let data = datas[index], let points = data.points, points.count > 1, let gradient = data.fill {
                        Rectangle()
                            .fill(gradient)
                            .clipShape(data.closePath(with: frame, maximum: maximum))
                            .blendMode(.sourceAtop)
                    }
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
                ForEach(0..<datas.count) { index in
                    if let data = datas[index], let points = data.points, points.count > 1, let color = data.stroke, let width = data.strokeWidth {
                        Path { path in
                            path = data.path(with: frame, maximum: maximum)
                        }
                        .stroke(color, lineWidth: width)
                    }
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
