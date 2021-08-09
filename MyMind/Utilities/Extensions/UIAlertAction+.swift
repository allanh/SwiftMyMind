//
//  UIAlertAction+.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, color: UIColor, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        setValue(color, forKey: "titleTextColor")
    }
}
