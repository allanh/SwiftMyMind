//
//  Double+.swift
//  MyMind
//
//  Created by Shih Allan on 2022/2/10.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import Foundation

extension Double {
    func toDecimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

extension Int {
    func toDecimalString() -> String {
        return Double(self).toDecimalString()
    }
}
