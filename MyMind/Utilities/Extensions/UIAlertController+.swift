//
//  UIAlertController+.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
extension UIAlertController {
    convenience init(title: NSAttributedString?, message: NSAttributedString?, preferredStyle: UIAlertController.Style) {
        self.init(title:title?.string, message:message?.string, preferredStyle:preferredStyle)
        setValue(title, forKey: "attributedTitle")
        setValue(message, forKey: "attributedMessage")
    }
}
