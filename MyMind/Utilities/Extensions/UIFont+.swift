//
//  UIFont+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import UIKit

extension UIFont {
    static func pingFangTCRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangTC-Regular", size: size)!
    }

    static func pingFangTCSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangTC-Semibold", size: size)!
    }
}
extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
}
