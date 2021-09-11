//
//  UIView+copy.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
extension UIView {
    func copyView() -> UIView {
        if #available(iOS 11.0, *) {
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [UIView.classForKeyedUnarchiver()], from: NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)) as! UIView
            } catch {}
        } else {
            // Fallback on earlier versions
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [UIView.classForKeyedUnarchiver()], from: NSKeyedArchiver.archivedData(withRootObject: self)) as! UIView
            } catch {}
        }
        return UIView(frame: CGRect.zero)
    }

}
