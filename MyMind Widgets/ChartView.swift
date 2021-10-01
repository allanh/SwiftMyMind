//
//  ChartView.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import SwiftUI
/// Chart View
struct ChartView : View {
    let entry: MyMindEntry
    @State var labels: [String] = ["", "", ""]
    var body : some View {
        ZStack {
            GeometryReader { geo in
                let frame = geo.frame(in: .named("chart parent"))
                if entry.points.count > 1 {
                    Rectangle()
                        .fill(LinearGradient(stops: [.init(color:  Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.8), location: 0), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.5), location: 0.3), .init(color: Color(red: 31.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, opacity: 0.0), location: 1)], startPoint: .top, endPoint: .bottom))
                        .clipShape(entry.closePath(with: frame))
                        .blendMode(.lighten)
                }
                Path { path in
                    path.move(to: CGPoint(x: frame.minX, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
                }
                .stroke(Color(red: 59.0/255.0, green: 82.0/255.0, blue: 105.0/255.0), lineWidth: 1)
                Path { path in
                    path.move(to: CGPoint(x: frame.minX+(frame.size.width)/3, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX+(frame.size.width)/3, y: frame.maxY))
                }
                .stroke(Color(red: 59.0/255.0, green: 82.0/255.0, blue: 105.0/255.0), lineWidth: 1)
                Path { path in
                    path.move(to: CGPoint(x: frame.minX+(frame.size.width)/1.5, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.minX+(frame.size.width)/1.5, y: frame.maxY))
                }
                .stroke(Color(red: 59.0/255.0, green: 82.0/255.0, blue: 105.0/255.0), lineWidth: 1)
                Path { path in
                    path.move(to: CGPoint(x: frame.maxX, y: frame.minY))
                    path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
                }
                .stroke(Color(red: 59.0/255.0, green: 82.0/255.0, blue: 105.0/255.0), lineWidth: 1)
                if entry.points.count > 1 {
                    Path { path in
                        path = entry.path(with: frame)
                    }
                    .stroke(Color(red: 127.0/255.0, green: 194.0/255.0, blue: 250.0/255.0), lineWidth: 3)
                }

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
                .frame(width: frame.size.width)
            }
        }
        .coordinateSpace(name: "chart parent")
    }
}
