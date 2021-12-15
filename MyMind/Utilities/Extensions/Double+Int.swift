//
//  Double+Int.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
