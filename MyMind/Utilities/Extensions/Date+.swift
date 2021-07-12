//
//  Date+.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
extension Date {
    var sevenDaysBefore: Self {
        get {
            return Calendar.current.date(byAdding: .day, value: -7, to: self)!
        }
    }
    var thirtyDaysBefore: Self {
        get {
            return Calendar.current.date(byAdding: .day, value: -30, to: self)!
        }
    }
}
