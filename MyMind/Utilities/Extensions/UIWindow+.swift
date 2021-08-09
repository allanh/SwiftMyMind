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
extension UIWindow {
    private func topViewController(controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController  {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tab = controller as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    var topMostViewController: UIViewController? {
        get {
            return topViewController(controller: rootViewController)
        }
    }
}
