//
//  IconView.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import SwiftUI
struct IconView: View {
    let iconName: String
    let background: [Color]
    let title: String
    let value: String?
    var body: some View {
        VStack(alignment: .leading) {
            Image(iconName)
                .frame(width: 30, height: 30, alignment: .center)
                .background(Color.white)
                .cornerRadius(15)
            Text(title)
                .font(.custom("PingFangTC-Regular", size: 12))
                .foregroundColor(.white)
            if let value = value, let number = Int(value)  {
                if number < 999 {
                    Text(value)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.leading, 8)
        .background(LinearGradient(colors: background, startPoint: .top, endPoint: .bottom))
        .cornerRadius(8)
    }
}
