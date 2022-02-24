//
//  UIApplication+.swift
//  MyMind
//
//  Created by Shih Allan on 2022/2/24.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return shared.statusBarFrame.height
        }
    }
}
