//
//  IndicatorView.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import SwiftUI
///  Indicator View
struct IndicatorView : View {
    let count: Int?
    let title: String
    let colors: [Color]
    var body : some View {
        HStack {
            Rectangle()
                .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                .blendMode(.sourceAtop)
                .frame(width: 4)
                .cornerRadius(2)
                .padding(.leading, 10)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("PingFangTC-Regular", size: 10))
                    .foregroundColor(.white)
                if let count = count {
                    if count < 999 {
                        Text("\(count)")
                            .font(.custom("PingFangTC-Semibold", size: 24))
                            .foregroundColor(.white)
                    } else {
                        Text("999+")
                            .font(.custom("PingFangTC-Semibold", size: 24))
                            .foregroundColor(.white)
                    }
                } else {
                    Text("-")
                        .font(.custom("PingFangTC-Semibold", size: 24))
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
    }
}
