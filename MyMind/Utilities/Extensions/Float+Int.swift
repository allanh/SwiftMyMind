//
//  Double+Int.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

extension Float {
    func roundToInt() -> Int? {
        if self >= Float(Int.min) && self < Float(Int.max) {
            return Int(self.rounded(.toNearestOrEven))
        } else {
            return nil
        }
    }
}
