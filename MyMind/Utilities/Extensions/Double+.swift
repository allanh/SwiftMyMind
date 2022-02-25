//
//  Double+.swift
//  MyMind
//
//  Created by Shih Allan on 2022/2/10.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

extension Double {
    func toDecimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    //
    func toDollarsString(dollarFont: UIFont? = nil, dollarColor: UIColor? = nil) -> NSMutableAttributedString {
        let amountText = NSMutableAttributedString.init(string: "\(self.toDecimalString()) 元")
        // set the custom font and color for the last char
        amountText.setAttributes([NSAttributedString.Key.font: dollarFont ?? UIFont.pingFangTCSemibold(ofSize: 14),
                                      NSAttributedString.Key.foregroundColor: dollarColor ?? UIColor.white],
                                 range: NSMakeRange(amountText.length-1, 1))
        return amountText
    }
}

extension Int {
    func toDecimalString() -> String {
        return Double(self).toDecimalString()
    }
}
