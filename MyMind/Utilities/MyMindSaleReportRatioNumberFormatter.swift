//
//  MyMindSaleReportRatioNumberFormatter.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
class MyMindSaleReportRatioNumberFormatter: NumberFormatter {
    override func string(from number: NSNumber) -> String? {
        if number.floatValue == 0.0 {
            return "--"
        }
        return super.string(from: number)
    }
}
