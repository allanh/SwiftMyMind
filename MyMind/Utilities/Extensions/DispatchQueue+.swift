//
//  DispatchQueue+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static func executeOnMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            main.async(execute: closure)
        }
    }
}
