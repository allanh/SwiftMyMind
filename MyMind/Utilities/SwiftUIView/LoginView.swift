//
//  LoginView.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import SwiftUI
struct LoginView: View {
    /// 直向或橫向 layout
    let isVerticalLayout: Bool
    
    var loginLabel: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(Color.orange)
            Text("尚未連線請先行登入")
                .font(.custom("PingFangTC-Regular", size: 12))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
    
    var loginButton: some View {
        Text("登入")
            .font(.custom("PingFangTC-Semibold", size: 14))
            .foregroundColor(Color(white: 84.0/255, opacity: 1.0))
            .frame(width: 84, height: 32)
            .background(Color.white)
            .cornerRadius(4)
    }
    
    var body: some View {
        Link(destination: URL(string: "mymindwidget://login")!) {
            if isVerticalLayout {
                VStack {
                    loginLabel
                    loginButton
                }
            } else {
                HStack {
                    loginLabel
                    loginButton
                }
            }
        }
    }
}
