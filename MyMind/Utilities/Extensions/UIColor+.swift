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
/// HSL
extension UIColor {
    static func component(with tc: CGFloat, p: CGFloat, q: CGFloat) -> CGFloat {
        var result: CGFloat
        if tc < (1/6) {
            result = p + ((q - p)*6*tc)
        } else if tc >= (1/6), tc < (1/2) {
            result = q
        } else if tc >= 0.5, tc < (2/3) {
            result = p + ((q - p)*6*(2/3-tc))
        } else {
            result = p
        }
        return result
    }
    convenience init(h: CGFloat, s: CGFloat, l:CGFloat) {
        var p:CGFloat, q:CGFloat, hk:CGFloat, tr: CGFloat, tg: CGFloat, tb: CGFloat, red: CGFloat, green:CGFloat, blue:CGFloat
        if s == 0 {
            red = l
            green = l
            blue = l
        } else {
            if l < 0.5 {
                q = l*(1+s)
            } else {
                q = l+s-(l*s)
            }
            p = 2*l-q
            hk = h/360
            tr = hk+(1/3)
            if tr < 0 {
                tr += 1
            } else if tr > 1 {
                tr -= 1
            }
            tg = hk
            if tg < 0 {
                tg += 1
            } else if tg > 1 {
                tg -= 1
            }
            tb = hk-(1/3)
            if tb < 0 {
                tb += 1
            } else if tb > 1 {
                tb -= 1
            }
            red = UIColor.component(with: tr, p: p, q: q)
            green = UIColor.component(with: tg, p: p, q: q)
            blue = UIColor.component(with: tb, p: p, q: q)
        }
        self.init(red: red, green: green, blue: blue, alpha:1.0)
    }
    var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
        get {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha : CGFloat = 0
            var h: CGFloat, s:CGFloat, l: CGFloat
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let maximum = max(red, green, blue)
            let minimum = min(red, green, blue)
            l = (maximum+minimum)/2
            if maximum == minimum {
                h = 0
            } else if maximum == red {
                if green >= blue {
                    h = 60*(green-blue)/(maximum-minimum)
                } else {
                    h = 60*(green-blue)/(maximum-minimum)+360
                }
            } else if maximum == green {
                h = 60*(blue-red)/(maximum-minimum)+120
            } else {
                h = 60*(red-green)/(maximum-minimum)+240
            }
            if l == 0, maximum == minimum {
                s = 0
            } else if l <= 0.5 {
                s = (maximum-minimum)/(maximum+minimum)
            } else {
                s = (maximum-minimum)/(2-(maximum+minimum))
            }
            return (h, s, l)
        }
    }
    var lighter: UIColor {
        get {
            let representation = hsl
            var l = representation.l + 0.15
            if l > 1 {
                l = 1
            }
            return UIColor(h: representation.h, s: representation.s, l: l)
        }
    }
    var darker: UIColor {
        get {
            let representation = hsl
            var l = representation.l - 0.15
            if l < 0 {
                l = 0
            }
            return UIColor(h: representation.h, s: representation.s, l: l)
        }
    }
}

/// Color palette
extension UIColor {
    static var mainPageTabBar: UIColor {
        get {
            return UIColor(hex: "060d32")
        }
    }
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
    static var tundora: UIColor {
        get {
            return UIColor(hex: "434343")
        }
    }
    static var azure: UIColor {
        get {
            return UIColor(hex: "3758a8")
        }
    }
    static var biscay: UIColor {
        get {
            return UIColor(hex: "1c4373")
        }
    }
    static var webOrange: UIColor {
        get {
            return UIColor(hex: "f5a700")
        }
    }
    static var athensGray: UIColor {
        get {
            return UIColor(hex: "f2f2f4")
        }
    }
    static var lochmara: UIColor {
        get {
            return UIColor(hex: "306ab2")
        }
    }
    static var oxfordBlue: UIColor {
        get {
            return UIColor(hex: "384053")
        }
    }
    static var vividRed: UIColor {
        get {
            return UIColor(hex: "f5222d")
        }
    }
}
