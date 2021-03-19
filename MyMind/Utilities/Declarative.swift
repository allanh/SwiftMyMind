//
//  Declarative.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import Foundation

protocol Declarative: AnyObject {
    init()
}

extension Declarative {

    init(configureHandler: (Self) -> Void) {
        self.init()
        configureHandler(self)
    }

}

extension NSObject: Declarative { }
