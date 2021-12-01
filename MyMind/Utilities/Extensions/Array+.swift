//
//  Array+.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
