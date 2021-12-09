//
//  Date+.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
extension Date {
    var yesterday: Self {
        get {
            return Calendar.current.date(byAdding: .day, value: -1, to: self)!
        }
    }
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
    
    // A string that contains the short date string representation of the current DateTime object.
    var shortDateString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd"
            // Convert Date to String
            return dateFormatter.string(from: self)
        }
    }
}
