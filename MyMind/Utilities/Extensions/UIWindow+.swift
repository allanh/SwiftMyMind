//
//  UIWindow+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIWindow {
    static var keyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
