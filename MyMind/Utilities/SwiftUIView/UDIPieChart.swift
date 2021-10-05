//
//  UDIPieChart.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/10/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import SwiftUI
struct UDIPieSlice: Shape {
    let startAngle: Double
    let endAngle: Double
    let holeRatio: Double?
  
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let alpha = CGFloat(startAngle)

        let center = CGPoint(x: rect.midX, y: rect.midY)

        if let ratio = holeRatio {
            path.move(to: CGPoint(x: center.x + cos(alpha) * radius * ratio, y: center.y + sin(alpha) * radius * ratio))
        } else {
            path.move(to: center)
        }

        path.addLine(to: CGPoint(x: center.x + cos(alpha) * radius, y: center.y + sin(alpha) * radius))

        path.addArc(center: center, radius: radius, startAngle: Angle(radians: startAngle), endAngle: Angle(radians: endAngle), clockwise: false)
        if let ratio = holeRatio {
            path.addLine(to: CGPoint(x: center.x + cos(CGFloat(endAngle)) * radius * ratio, y: center.y + sin(CGFloat(endAngle)) * radius * ratio))
            path.addArc(center: center, radius: radius * ratio, startAngle: Angle(radians: endAngle), endAngle: Angle(radians: startAngle), clockwise: true)
        } else {
            path.closeSubpath()
        }
        return path
    }
}
struct UDIPieSliceText: View {
    let title: String
    let description: String
    let color: Color
  
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(color)
                .font(.custom("PingFangTC-Semibold", size: 10))
            Text(description)
                .foregroundColor(color)
                .font(.custom("PingFangTC-Regular", size: 8))
        }
    }
}
struct UDIPieSliceData {
    let ratio: Double
    let title: String
    let color: Color
}
struct UDIPieChartData {
    let slices: [UDIPieSliceData]
    let borderColor: Color
    let holeRatio: Double?
    let title: String?
}
struct UDIPieChartView : View {
    let data: UDIPieChartData
    let showDescription: Bool
    private let sliceOffset: Double = -.pi / 2
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                ZStack(alignment: .center) {
                    ForEach(0..<data.slices.count) { index in
                        UDIPieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index), holeRatio: data.holeRatio)
                            .fill(data.slices[index].color)
                        UDIPieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index), holeRatio: data.holeRatio)
                            .stroke(data.borderColor, lineWidth: 1)
//                        PieSliceText(
//                            title: "\(data.slices[index].title)",
//                            description: String(format: "%.2f%%", data.slices[index].ratio*100), color: .white
//                                  )
//                                  .offset(textOffset(for: index, in: geo.size))
//                                  .zIndex(1)
                    }
                    if let title = data.title {
                        Text(title)
                            .font(.custom("PingFangTC-Semibold", size: 24))
                            .foregroundColor(Color(white: 0.45))
                    }

                }
                .frame(maxHeight: geo.size.width)
                if showDescription {
                    ForEach(0..<data.slices.count) { index in
                        HStack {
                            Circle()
                                .fill(data.slices[index].color)
                                .frame(width: 20, height: 20)
                            Text(data.slices[index].title)
                            Spacer()
                            Text(String(format: "%.2f%%", data.slices[index].ratio*100))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                }
            }
            .background(Color.white)
        }
    }
    private func startAngle(for index: Int) -> Double {
        switch index {
        case 0:
            return sliceOffset
        default:
            let ratio: Double = data.slices[..<index].map({$0.ratio}).reduce(0.0, +) / data.slices.map({$0.ratio}).reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    private func endAngle(for index: Int) -> Double {
        switch index {
        case data.slices.count - 1:
          return sliceOffset + 2 * .pi
        default:
            let ratio: Double = data.slices[..<(index + 1)].map({$0.ratio}).reduce(0.0, +) / data.slices.map({$0.ratio}).reduce(0.0, +)
          return sliceOffset + 2 * .pi * ratio
        }
    }
    private func textOffset(for index: Int, in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height) / 3
        let dataRatio = (2 * data.slices[..<index].map({$0.ratio}).reduce(0, +) + data.slices[index].ratio) / (2 * data.slices.map({$0.ratio}).reduce(0, +))
        let angle = CGFloat(sliceOffset + 2 * .pi * dataRatio)
        return CGSize(width: radius * cos(angle), height: radius * sin(angle))
      }
}

struct UDIPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        UDIPieChartView(data: UDIPieChartData(slices: [UDIPieSliceData(ratio: 0.3, title: "Yahoo", color: .red), UDIPieSliceData(ratio: 0.4, title: "Shoppe", color: .green), UDIPieSliceData(ratio: 0.3, title: "PCHome", color: .blue)], borderColor: .white, holeRatio: 0.5, title: "供應商"), showDescription: true)
            .background(Color.black)
    }
}
