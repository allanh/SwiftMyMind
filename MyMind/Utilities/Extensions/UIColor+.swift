//
//  UIColor+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        guard cString.count == 6 else {
            self.init(
                red: 0.0,
                green: 0.0,
                blue: 0.0,
                alpha: CGFloat(1.0)
            )
            return
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
/// Color palette
extension UIColor {
    static var prussianBlue: UIColor {
        get {
            return UIColor(hex: "004477")
        }
    }
    static var veryLightPink: UIColor {
        get {
            return UIColor(hex: "f2f2f2")
        }
    }
    static var brownGrey: UIColor {
        get {
            return UIColor(hex: "7f7f7f")
        }
    }
    static var brownGrey2: UIColor {
        get {
            return UIColor(hex: "b4b4b4")
        }
    }
    static var emperor: UIColor {
        get {
            return UIColor(hex: "545454")
        }
    }
    static var mercury: UIColor {
        get {
            return UIColor(hex: "e5e5e5")
            
        }
    }
    static var veryDarkGray: UIColor {
        get {
            return UIColor(hex: "4c4c4c")
        }
    }
}
