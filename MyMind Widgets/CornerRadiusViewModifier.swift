//
//  CornerRadiusViewModifier.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import SwiftUI
struct CornerRadiusViewModifier: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
